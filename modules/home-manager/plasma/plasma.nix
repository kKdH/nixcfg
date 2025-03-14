{ lib, config, ... }:

#### Getting the app IDs
# run   'ls /run/current-system/sw/share/applications'             for programs installed via the system config
# run   'ls /etc/profiles/per-user/<username>/share/applications'  for programs installed via Home Manager
# run   'ls /run/current-system/sw/share/plasma/plasmoids'         for the plasmoids
# there is more in '/run/current-system/sw/share/plasma'

{
  options.plasma = {
    enable = lib.mkEnableOption "Enables KDE Plasma configuration.";
  };

  config = lib.mkIf config.plasma.enable {
    programs.plasma = {
      enable = true;
      overrideConfig = true;
      kscreenlocker = {
        autoLock = false;
      };
      workspace = {
        lookAndFeel = "org.kde.breezedark.desktop";
        theme = "breeze-dark";
      };
      input = {
        keyboard = {
          numlockOnStartup = "on";
        };
      };
      shortcuts = {
        "services/firefox-devedition.desktop"."_launch" = "Ctrl+Alt+F";
        "services/org.kde.konsole.desktop"."_launch" = "";
        "services/org.wezfurlong.wezterm.desktop"."_launch" = "Ctrl+Alt+T";
      };
      panels = [
        {
          screen = 0;
          location = "left";
          floating = true;
          widgets = [
            # Or you can configure the widgets by adding the widget-specific options for it.
            # See modules/widgets for supported widgets and options for these widgets.
            # For example:
            {
              kickoff = {
                sortAlphabetically = true;
                icon = "nix-snowflake-white";
              };
            }
            # Adding configuration to the widgets can also for example be used to
            # pin apps to the task-manager, which this example illustrates by
            # pinning dolphin and konsole to the task-manager by default with widget-specific options.
            {
              iconTasks = {
                launchers = [
                  "applications:org.kde.dolphin.desktop"
                  "applications:org.wezfurlong.wezterm.desktop"
                  "applications:firefox-devedition.desktop"
                ];
              };
            }
            # If no configuration is needed, specifying only the name of the
            # widget will add them with the default configuration.
            "org.kde.plasma.marginsseparator"
            # If you need configuration for your widget, instead of specifying the
            # the keys and values directly using the config attribute as shown
            # above, plasma-manager also provides some higher-level interfaces for
            # configuring the widgets. See modules/widgets for supported widgets
            # and options for these widgets. The widgets below shows two examples
            # of usage, one where we add a digital clock, setting 12h time and
            # first day of the week to Sunday and another adding a systray with
            # some modifications in which entries to show.
            {
              digitalClock = {
                calendar = {
                  firstDayOfWeek = "monday";
                  showWeekNumbers = true;
                };
                date.format = "isoDate";
                time.format = "24h";
              };
            }
            {
              systemTray.items = {
                shown = [
                  "org.kde.plasma.volume"
                  "org.kde.plasma.microphone"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.battery"
                ];
                hidden = [
                  "org.kde.plasma.bluetooth"
                  "org.kde.plasma.brightness"
                  "org.kde.plasma.clipboard"
                ];
              };
            }
          ];
        }
      ];
    };
  };
}
