[
  {
    # Toolbar Folder
    name = "toolbar";
    toolbar = true;
    bookmarks = [
      {
      name = "example";
      bookmarks = [
        {
          name = "example";
          url = "https://example.com";
          keyword = "example";
        }
      ];
      }
    ];
  }
  {
  name = "GitHub";
    tags = [ "git" "github" "collaboration" ];
    keyword = "git";
    url = "https://github.com/";
  }
  {
    name = "Element";
    tags = [ "matrix" "chat" "collaboration" ];
    keyword = "matrix";
    url = "https://app.element.io/";
  }
  {
    name = "Discord";
    tags = [ "chat" "collaboration" ];
    keyword = "discord";
    url = "https://discord.com/";
  }
  {
    name = "Office";
    bookmarks = [
      {
        name = "Outlook";
        tags = [ "office" "mail" "collaboration" ];
        keyword = "";
        url = "https://outlook.office.com/";
      }
      {
        name = "Microsoft Teams";
        tags = [ "teams" "collaboration" ];
        keyword = "teams";
        url = "https://teams.microsoft.com/v2/#";
      }
    ];
  }
  {
    name = "Construction";
    bookmarks = [
      {
        name = "OnShape";
        tags = [ "construction" "cad" ];
        keyword = "cad";
        url = "https://cad.onshape.com/";
      }
      {
        name = "Prusa Connect";
        tags = [ "construction" "prusa" "3d-printing" ];
        keyword = "printer";
        url = "https://account.prusa3d.com/";
      }
      {
        name = "Prusa Shop";
        tags = [ "construction" "shop" "prusa" "3d-printing" ];
        keyword = "prusa";
        url = "https://www.prusa3d.com/";
      }
      {
        name = "Printables";
        tags = [ "construction" "prusa" "3d-printing" ];
        url = "https://www.printables.com/";
      }
      {
        name = "Fiberlogy";
        tags = [ "construction" "shop" "3d-printing" "filament" ];
        keyword = "";
        url = "https://fiberlogy.com/";
      }
      {
        name = "Frantos";
        tags = [ "shop" "bolts" "nuts" "schrauben" "muttern" ];
        url = "https://www.frantos.com/";
      }
      {
        name = "Kugellager Express";
        tags = [ "construction" "shop" "3d-printing" ];
        url = "https://www.kugellager-express.de/";
      }
      {
        name = "CNC Kitchen";
        tags = [ "construction" "shop" "3d-printing" ];
        url = "https://cnckitchen.store/";
      }
    ];
  }
  {
    name = "Rust";
    bookmarks = [
      {
        name = "Rust";
        tags = [ "programming" "rust" ];
        url = "https://www.rust-lang.org/";
      }
      {
        name = "Rust Blogs";
        bookmarks = [
          {
            name = "Yoshua Wuyts";
            tags = [ "programming" "blog" "rust" ];
            url = "https://blog.yoshuawuyts.com/";
          }
          {
            name = "Without boats";
            tags = [ "programming" "blog" "rust" ];
            url = "https://without.boats/";
          }
          {
            name = "Babysteps - Niko Matsakis";
            tags = [ "programming" "blog" "rust" ];
            url = "https://smallcultfollowing.com/babysteps/";
          }
          {
            name = "This Week in Rust";
            tags = [ "programming" "blog" "rust" ];
            url = "https://this-week-in-rust.org/";
          }
        ];
      }
    ];
  }
  {
    name = "Electronics";
    bookmarks = [
      {
        name = "Mouser";
        tags = [ "electronics" "shop" "smart-home" ];
        keyword = "mouser";
        url = "https://www.mouser.de";
      }
      {
        name = "Botland";
        tags = [ "electronics" "shop" "smart-home" ];
        keyword = "botland";
        url = "https://botland.store";
      }
      {
        name = "Voelkner";
        tags = [ "shop" "smart-home" ];
        url = "https://www.voelkner.de/";
      }
      {
        name = "SmartKram";
        tags = [ "shop" "smart-home" ];
        url = "https://smartkram.de/";
      }
      {
        name = "KT Micro";
        tags = [ "electronics" "shop" "fr4" "circuit boards" ];
        url = "https://www.kt-micro.de/";
      }
      {
        name = "Feltron Zeissler";
        tags = [ "electronics" "shop" "montageplatte" "käfigmutter" ];
        url = "https://feltron-zeissler.de/";
      }
      {
        name = "ST";
        bookmarks = [
          {
            name = "ST";
            tags = [ "electronics"  ];
            url = "https://www.st.com/";
          }
          {
            name = "STm32 Nucleo Boards";
            tags = [ "electronics" "stm32" "nucleo" ];
            url = "https://www.st.com/en/evaluation-tools/stm32-nucleo-boards.html";
          }
          {
            name = "Nucleo";
            bookmarks = [
              {
                name = "Nucleo F446";
                tags = [ "electronics" "stm32" "nucleo" "f4" "f446" ];
                url = "https://www.st.com/en/evaluation-tools/nucleo-f446re.html";
              }
              {
                name = "Nucleo F446 Datasheet (PDF)";
                tags = [ "electronics" "datasheet" "stm32" "nucleo" "f4" "f446" "pdf" ];
                url = "https://www.st.com/resource/en/datasheet/stm32f446re.pdf";
              }
              {
                name = "Nucleo F446 Manuel (PDF)";
                tags = [ "electronics" "manual" "stm32" "nucleo" "f4" "f446" "pdf" ];
                url = "https://www.st.com/resource/en/user_manual/um1724-stm32-nucleo64-boards-mb1136-stmicroelectronics.pdf";
              }
              {
                name = "Nucleo G431";
                tags = [ "electronics" "stm32" "nucleo" "g4" "g431" ];
                url = "https://www.st.com/en/evaluation-tools/nucleo-g431kb.html#documentation";
              }
              {
                name = "Nucleo G431 Datasheet (PDF)";
                tags = [ "electronics" "datasheet" "stm32" "nucleo" "g4" "g431" "pdf" ];
                url = "https://www.st.com/resource/en/datasheet/stm32g431c6.pdf";
              }
              {
                name = "Nucleo G431 Manual (PDF)";
                tags = [ "electronics" "manual" "stm32" "nucleo" "g4" "g431" "pdf" ];
                url = "https://www.st.com/resource/en/user_manual/dm00493601-stm32g4-nucleo-32-board-mb1430-stmicroelectronics.pdf";
              }            ];
              
          }
        ];
      }
      {
        name = "Ti";
        tags = [ "electronics" ];
        url = "https://www.ti.com/";
      }
      {
        name = "CAN Bit Timing";
        tags = [ "electronics" "can" "timing" "help" ];
        url = "http://www.bittiming.can-wiki.info";
      }
      {
        name = "Mouser Inventory";
        tags = [ "electronics" ];
        url = "https://inventory.mouser.com";
      }
    ];
  }
  {
    name = "Dict";
    tags = [ "dictionray" "translate" "english" "german" ];
    keyword = "dict";
    url = "https://www.dict.cc/";
  }
  {
    name = "Apple Music";
    tags = [ "apple" "music" "player" ];
    keyword = "music";
    url = "https://music.apple.com/";
  }
  {
    name = "Apple iCloud";
    tags = [ "apple" "icloud" "drive" ];
    keyword = "icloud";
    url = "https://www.icloud.com/iclouddrive/";
  }
  {
    name = "News";
    bookmarks = [
      {
        name = "Heise";
        tags = [ "news" ];
        keyword = "heise";
        url = "https://heise.de/";
      }
      {
        name = "Golem";
        tags = [ "news" ];
        keyword = "golem";
        url = "https://golem.de/";
      }
      {
        name = "TV";
        bookmarks = [
          {
            name = "ZDF";
            tags = [ "news" "tv" ];
            keyword = "zdf";
            url = "https://www.zdf.de/";
          }
          {
            name = "Tageschau24";
            tags = [ "news" "tv" ];
            keyword = "tagesschau";
            url = "https://www.tagesschau.de/thema/tagesschau24";
          }
        ];
      }
    ];
  }
  {
    name = "Programming";
    bookmarks = [
      {
        name = "Regexper";
        tags = [ "programming" "regex" ];
        url = "https://regexper.com/";
      }
      {
        name = "Regex101";
        tags = [ "programming" "regex" ];
        url = "https://regex101.com/";
      }
    ];
  }
  {
    name = "Nix";
    bookmarks = [
      {
        name = "NixOS And Flakes";
        tags = [ "nix" "nixos" "flakes" "home-manager" "getting started" "tutorial" ];
        url = "https://nixos-and-flakes.thiscute.world/";
      }
    ];
  }
  {
    name = "Misc";
    bookmarks = [
      {
        name = "Kleinanzeigen";
        tags = [ "shop" ];
        keyword = "klein";
        url = "https://www.kleinanzeigen.de/";
      }
      {
        name = "Maschinensucher";
        url = "https://www.maschinensucher.de";
      }
      {
        name = "Wikipedia";
        tags = [ "wiki" ];
        keyword = "wiki";
        url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
      }
      {
        name = "eBooks";
        tags = [];
        keyword = "ebooks";
        url = "https://www.ebooks.com/";
      }
      {
        name = "WebDev";
        tags = [ "localhost" "dev" ];
        keyword = "webdev";
        url = "http://localhost:8000/";
      }
      {
        name = "Diagrams.net";
        tags = [];
        url = "https://app.diagrams.net";
      }
      {
        name = "Bing Image Creator";
        tags = [];
        url = "https://www.bing.com/images/create";
      }
      {
        name = "Typst";
        tags = [];
        keyword = "typst";
        url = "https://typst.app/";
      }
      {
        name = "PC Part Picker";
        url = "https://de.pcpartpicker.com/list/dtPsLc";
      }
      {
        name = "Google Maps";
        tags = [ "google" ];
        keyword = "maps";
        url = "https://www.google.com/maps";
      }
    ];
  }
  {
    name = "Work";
    bookmarks = [
      {
        name = "Timetracking";
        tags = [ "work" ];
        keyword = "time";
        url = "https://timetracking.mercedes-benz-techinnovation.com/";
      }
      {
        name = "Artifactory";
        tags = [ "work" ];
        url = "https://artifacts.i.mercedes-benz.com/ui/";
      }
      {
        name = "Mattermost";
        tags = [ "work" ];
        url = "https://matter.i.mercedes-benz.com/";
      }
      {
        name = "Workday";
        tags = [ "work" ];
        url = "https://wd3.myworkday.com/mercedesbenztechinnovation/d/pex/home.htmld";
      }
      {
        name = "Github Cloud Enterprise";
        tags = [ "work" ];
        url = "https://mercedes-benz.ghe.com/";
      }
    ];
  }
]
