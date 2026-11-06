{ ... }:
{
  flake.nixosModules.jovian = { ... }: {

    services.displayManager.defaultSession = "gamescope-wayland";

    services = {
      xserver = {
        enable = true;
        displayManager = {
          gdm.enable = false; # Cannot be enabled if jovian autostart is in use.
          startx.enable = false; # IMPORTANT!!! GAMESCOPE CANT LAUNCH WITHOUT
        };
      };
      desktopManager.plasma6.enable = true;
    };
  };

  jovian = {
    devices.steamdeck.enable = true;
    steam = {
      enable = true;
      user = "froggi";
      autoStart = true;
      desktopSession = "plasma";
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
}
