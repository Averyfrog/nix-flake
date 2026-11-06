{ ... }:
{

  flake.nixosModules.sddm =
    { pkgs, lib, ... }:

    let
      background = pkgs.runCommand "background-image" { } ''
        cp ${./wallpaper.jpg} $out
      '';
    in
    {
      # X11 and KDE Plasma configuration
      services.xserver.enable = true;
      services.displayManager.sddm = {
        enable = lib.mkDefault true;
        theme = "breeze";
        wayland.enable = true;
      };
      environment.systemPackages = [
        (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
          [General]
          background = "${background}"
        '')
      ];

      /*
        systemd.services."display-manager" = {
          conflicts = [ "plymouth-quit.service" ];
          preStart = "${pkgs.plymouth}/bin/plymouth deactivate";
          script = "/run/current-system/sw/bin/sddm";
          postStart = "/bin/sh -c 'sleep 5 && ${pkgs.plymouth}/bin/plymouth quit --retain-splash'";
          enable = true;
          startLimitBurst = lib.mkForce 10;
        };
      */

    };
}
