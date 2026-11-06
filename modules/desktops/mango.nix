{ inputs, ... }:
{
  flake.nixosModules.mango =
    { pkgs, ... }:
    {
      imports = [
        inputs.mangowm.nixosModules.mango
      ];

      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config.common.default = "*";
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      programs.mango = {
        enable = true;
      };

      home-manager.sharedModules = [
        {

        }
      ];
    };
}
