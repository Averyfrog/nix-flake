{ ... }:
{
  flake.nixosModules.theming =
    { pkgs, ... }:

    {
      qt = {
        enable = true;
        platformTheme = "qt6ct-kde";
        style = "Darkly";
      };

      home-manager.sharedModules = [
        {
          qt = {
            enabled = true;
            style = {
              package = pkgs.darkly;
            };
          };
        }
        {
          gtk = {
            enable = true;

            cursorTheme = {
              name = "BreezeX-RosePineDawn-Linux";
              package = pkgs.rose-pine-cursor;
              size = 32;
            };

            font = {
              name = "Jost*";
              package = pkgs.jost;
              size = 12;
            };

          };
        }
      ];

    };
}
