{ lib, config, pkgs, ... }:

let
  slicerConfigDir = "${config.xdg.configHome}/PrusaSlicer";
  filamentConfigDir = "${slicerConfigDir}/filament";
  printConfigDir = "${slicerConfigDir}/print";
  printerConfigDir = "${slicerConfigDir}/printer";

  cfg = config.prusa-slicer;

  nlohmann_json_patched = pkgs.nlohmann_json.overrideAttrs (old: {
    patches = (old.patches or []) ++ [ ./json.patch ];
  });

  prusaSlicerSrc = pkgs.fetchFromGitHub {
    owner = "prusa3d";
    repo = "PrusaSlicer";
    rev = cfg.revision;
    hash = cfg.srcHash;
  };

  libassert = pkgs.stdenv.mkDerivation {
    pname = "libassert";
    version = "2.2.1";
    src = pkgs.fetchFromGitHub {
      owner = "jeremy-rifkin";
      repo = "libassert";
      rev = "v2.2.1";
      hash = "sha256-ognudQ3NgpYxiDEucbIRWYQPs0XLRUQwg1eMxJm+aPs=";
    };
    nativeBuildInputs = [ pkgs.cmake ];
    buildInputs = [ pkgs.cpptrace ];
    cmakeFlags = [
      "-DLIBASSERT_USE_EXTERNAL_CPPTRACE=ON"
      "-DBUILD_TESTING=OFF"
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
    ];
  };

  prusa-fdm-mixer = pkgs.stdenv.mkDerivation {
    pname = "prusa_fdm_mixer";
    version = "1.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "prusa3d";
      repo = "prusa-fdm-mixer";
      rev = "09d372aeccb4f7b9a0efbe59d99d70dba196814a";
      hash = "sha256-3t4K+T8uRaAyhbTQTwM+sEmbYCAMrsh4jaGtTLKxMGw=";
    };
    sourceRoot = "source/cpp";
    nativeBuildInputs = [ pkgs.cmake ];
    cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.10" ];
    postPatch = ''
      cp ${./prusa_fdm_mixer/CMakeLists.txt} CMakeLists.txt
      cp ${./prusa_fdm_mixer/Config.cmake.in} Config.cmake.in
    '';
  };

  yoga = pkgs.stdenv.mkDerivation {
    pname = "yoga";
    version = "3.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "facebook";
      repo = "yoga";
      rev = "v3.1.0";
      hash = "sha256-Y/BHMAfMUBY2Z5VV6rZkBGMs8II+r6MWXM6oV+nxtaQ=";
    };
    nativeBuildInputs = [ pkgs.cmake ];
    cmakeFlags = [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.13"
      "-DCMAKE_BUILD_TYPE=Release"
    ];
    postPatch = ''
      sed -i 's/add_subdirectory(tests)/# add_subdirectory(tests)/' CMakeLists.txt
      sed -i '/-fno-rtti/d' cmake/project-defaults.cmake
      sed -i 's/-Werror//' cmake/project-defaults.cmake
    '';
    preInstall = ''
      cd $src
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib $out/include $out/include/yoga $out/lib/cmake/yoga
      find $NIX_BUILD_TOP -name "libyogacore.a" -exec cp {} $out/lib/ \;
      cp yoga/*.h $out/include/
      cp yoga/*.h $out/include/yoga/
      cat > $out/lib/cmake/yoga/yogaConfig.cmake << EOF
      add_library(yoga::yogacore STATIC IMPORTED)
      set_target_properties(yoga::yogacore PROPERTIES
        IMPORTED_LOCATION "$out/lib/libyogacore.a"
        INTERFACE_INCLUDE_DIRECTORIES "$out/include"
      )
      add_library(yoga::yoga ALIAS yoga::yogacore)
      EOF
      cat > $out/lib/cmake/yoga/yogaConfigVersion.cmake << EOF
      set(PACKAGE_VERSION "3.1.0")
      set(PACKAGE_VERSION_EXACT FALSE)
      set(PACKAGE_VERSION_COMPATIBLE TRUE)
      EOF
      runHook postInstall
    '';
  };

  customPrusaSlicer = (pkgs.prusa-slicer.override {
    wxGTK-override = pkgs.wxwidgets_3_3;
  }).overrideAttrs (finalAttrs: prevAttrs: {
    version = lib.removePrefix "version_" cfg.revision;
    src = prusaSlicerSrc;
    patches = [ ];
    buildInputs = (lib.filter (p: p != pkgs.nlohmann_json) prevAttrs.buildInputs) ++ [
      pkgs.fmt
      pkgs.tracy
      pkgs.glfw3
      pkgs.SDL2
      pkgs.tl-expected
      pkgs.spdlog
      pkgs.cpptrace
      pkgs.c-blosc
      pkgs.lua
      pkgs.sol2
      pkgs.cli11
      pkgs.pugixml
      pkgs.magic-enum
      pkgs.range-v3
      pkgs.libdeflate
      pkgs.yaml-cpp
      pkgs.libfyaml
      pkgs.wxwidgets_3_3
      nlohmann_json_patched
      libassert
      prusa-fdm-mixer
      yoga
    ];
    cmakeFlags = prevAttrs.cmakeFlags ++ [
      "-DSLIC3R_YAML=yaml-cpp"
      "-DSLIC3R_BUILD_TESTS=OFF"
    ];
    env = prevAttrs.env // {
      NIX_CFLAGS_COMPILE = (prevAttrs.env.NIX_CFLAGS_COMPILE or "") + " -DJSON_USE_IMPLICIT_CONVERSIONS=0";
    };
    prePatch = ''
      if [ -f cmake/modules/FindNLopt.cmake ]; then
        sed -i 's|nlopt_cxx|nlopt|g' cmake/modules/FindNLopt.cmake
      fi
      if [ -f tests/slic3rutils/CMakeLists.txt ]; then
        sed -i 's|slic3r_jobs_tests.cpp||g' tests/slic3rutils/CMakeLists.txt
      fi
      if [ -f src/libslic3r/Format/STEP.cpp ]; then
        substituteInPlace src/libslic3r/Format/STEP.cpp \
          --replace-fail 'libpath /= "OCCTWrapper.so";' 'libpath = "OCCTWrapper.so";'
      fi
      if [ -f cmake/modules/FindEXPAT.cmake ]; then
        rm cmake/modules/FindEXPAT.cmake
      fi
      if [ -f src/slic3r-platform-wx/CMakeLists.txt ]; then
        substituteInPlace src/slic3r-platform-wx/CMakeLists.txt \
          --replace-fail 'find_package(wxWidgets 3.3 CONFIG REQUIRED' 'find_package(wxWidgets 3.3 REQUIRED'
      fi
      if [ -f src/slic3r-biz-crypto/src/Slic3r/Biz/Crypto/Types.cpp ]; then
        sed -i '1i #include <cstring>' src/slic3r-biz-crypto/src/Slic3r/Biz/Crypto/Types.cpp
      fi
      if [ -f src/slic3r-shared-wx/src/Slic3r/App/WX/Widgets/Button.cpp ]; then
        sed -i 's/state_handler\.attach({&text_color});/state_handler.attach(std::vector<StateColor const*>{\&text_color});/' src/slic3r-shared-wx/src/Slic3r/App/WX/Widgets/Button.cpp
      fi
      if [ -f src/${
        if finalAttrs.pname == "prusa-slicer" then "CLI/Setup.cpp" else "PrusaSlicer.cpp"
      } ]; then
        substituteInPlace src/${
          if finalAttrs.pname == "prusa-slicer" then "CLI/Setup.cpp" else "PrusaSlicer.cpp"
        } \
          --replace-fail "#ifdef __APPLE__" "#if 0"
      fi
    '';
    postInstall = ''
      if [ -f "$out/bin/slic3r-app-launcher" ]; then
        ln -sf "$out/bin/slic3r-app-launcher" "$out/bin/prusa-slicer"
        ln -sf "$out/bin/prusa-slicer" "$out/bin/prusa-gcodeviewer"
      else
        ln -s "$out/bin/prusa-slicer" "$out/bin/prusa-gcodeviewer"
      fi

      mkdir -p "$out/lib"
      mv -v $out/bin/*.* $out/lib/ 2>/dev/null || true

      mkdir -p "$out"/share/mime/packages
      cat << EOF > "$out"/share/mime/packages/prusa-gcode-viewer.xml
      <?xml version="1.0" encoding="UTF-8"?>
      <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
        <mime-type type="application/x-bgcode">
          <comment xml:lang="en">Binary G-code file</comment>
          <glob pattern="*.bgcode"/>
        </mime-type>
      </mime-info>
      EOF
    '';
  });
in
{
  options.prusa-slicer = {
    enable = lib.mkEnableOption "Enable Prusa Slicer";
    revision = lib.mkOption {
      type = lib.types.str;
      default = "version_2.9.6";
      description = "Complete revision string (git ref, tag or branch) for PrusaSlicer source";
    };
    srcHash = lib.mkOption {
      type = lib.types.str;
      default = lib.fakeHash;
      description = "SRI hash for the PrusaSlicer source at the given revision";
    };
  };
  config = lib.mkIf config.prusa-slicer.enable {
    home.packages = [
      customPrusaSlicer
    ];
    home.file = {
      ${filamentConfigDir} = {
        source = ./filament;
        recursive = true;
      };
      ${printConfigDir} = {
        source = ./print;
        recursive = true;
      };
      ${printerConfigDir} = {
        source = ./printer;
        recursive = true;
      };
    };
  };
}
