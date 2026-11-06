{
  self,
  ...
}:

{
  flake.nixosModules.starfishConfiguration =
    {
      ...
    }:
    {
      imports = with self.nixosModules; [

        starfishHardware
        starfishUsers
        starfishPackages
        starfishBoot

        hyprland
        terminal
        kitty
        discord
        neovim
        zed
        zen
        sddm
        music
        #mango

      ];

      networking = {
        hostName = "starfish"; # Define your hostname.
        networkmanager.enable = true;
        proxy = {
          #default = "http://user:password@proxy:port/";
          #noProxy = "127.0.0.1,localhost,internal.domain";
        };
        firewall = {
          enable = false;
          allowedTCPPorts = [
            25565
            24454
          ];
          allowedUDPPorts = [ 25565 ];
        };
      };

      services.openssh.enable = true;
      hardware.bluetooth.enable = true;

      time.timeZone = "Europe/London";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_GB.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_GB.UTF-8";
        LC_IDENTIFICATION = "en_GB.UTF-8";
        LC_MEASUREMENT = "en_GB.UTF-8";
        LC_MONETARY = "en_GB.UTF-8";
        LC_NAME = "en_GB.UTF-8";
        LC_NUMERIC = "en_GB.UTF-8";
        LC_PAPER = "en_GB.UTF-8";
        LC_TELEPHONE = "en_GB.UTF-8";
        LC_TIME = "en_GB.UTF-8";
      };

      services = {
        xserver.enable = true;
        desktopManager.plasma6.enable = true;
      };

      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        #jack.enable = true;

        #media-session.enable = true;
      };

      nixpkgs.config.allowUnfree = true;

      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          substituters = [ "https://hyprland.cachix.org" ];
          trusted-substituters = [ "https://hyprland.cachix.org" ];
          trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
        };

      };

      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
        flake = "/home/avafrog/nix-flake";
      };

      system.stateVersion = "25.05"; # Avery DONT CHANGE IT

    };

}
