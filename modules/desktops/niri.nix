{ inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config.common.default = "*";
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      programs.niri = {
        enable = true;
      };

      home-manager.sharedModules = [
        inputs.niri.homeModules.niri
        {
          programs.niri = {
            enable = true;

            settings = {

              prefer-no-csd = true;

              outputs."eDP-1" = {
                scale = 1.25;
              };

              spawn-at-startup = [
                { sh = "qs -p ~/Projects/shell/shell.qml"; }
              ];

              xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

              input = {
                keyboard.xkb.layout = "us";
                touchpad.natural-scroll = false;
              };

              layout = {
                gaps = 16;

                default-column-display = "tabbed";

                tab-indicator = {
                  hide-when-single-tab = true;
                };

                /*
                  preset-column-widths = [
                    { proportion = 0.333; }
                    { proportion = 0.5; }
                    { proportion = 1; }
                  ];
                */

              };

              binds = {
                "Mod+Return".action.spawn-sh = lib.getExe pkgs.kitty;
                "Mod+X".action.close-window = [ ];
                #"Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
              };

            };

          };
        }
      ];
    };

  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      packages.niriPackage = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          outputs."eDP-1".scale = 1.0;

          spawn-at-startup = [
            #(lib.getExe self'.packages.myNoctalia)
          ];

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input.keyboard.xkb.layout = "us,ua";

          layout.gaps = 8;

          binds = {
            "Mod+Return".action.spawn-sh = lib.getExe pkgs.kitty;
            "Mod+Q".action.close-window = null;
            #"Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          };
        };
      };
    };
}
