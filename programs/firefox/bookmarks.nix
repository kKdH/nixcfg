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
                name = "Nucleo F446 Datasheet";
                tags = [ "electronics" "datasheet" "stm32" "nucleo" "f4" "f446" ];
                url = "https://www.st.com/resource/en/datasheet/stm32f446re.pdf";
              }
              {
                name = "Nucleo F446 Manuel";
                tags = [ "electronics" "manual" "stm32" "nucleo" "f4" "f446" ];
                url = "https://www.st.com/resource/en/user_manual/dm00493601-stm32g4-nucleo-32-board-mb1430-stmicroelectronics.pdf";
              }
              {
                name = "Nucleo G431 Datasheet";
                tags = [ "electronics" "datasheet" "stm32" "nucleo" "g4" "g431" ];
                url = "https://www.st.com/resource/en/datasheet/stm32g431c6.pdf";
              }
              {
                name = "Nucleo G431 Manual";
                tags = [ "electronics" "manual" "stm32" "nucleo" "g4" "g431" ];
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
        name = "RepoCar";
        tags = [ "work" ];
        keyword = "repocar";
        url = "https://repocar.detss.corpintra.net/";
      }
      {
        name = "DHC";
        tags = [ "work" "dhc" "cloud" "kubernetes" "aws" "azure" "container" ];
        keyword = "dhc";
        url = "https://dhc-portal.app.corpintra.net/";
      }
    ];
  }
]
