# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ self, ... }:

{
  flake.nixosModules.anomalocarisConfiguration =
    {
      inputs,
      pkgs,
      ...
    }:
    {
      imports = with self.nixosModules; [
        anomalocarisHardware
        anomalocarisPackages

        inputs.home-manager.nixosModules.default

        jovian
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

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "Anomalocaris"; # Define your hostname.

      home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users.froggi = {

          home = {
            username = "froggi";
            homeDirectory = "/home/froggi";
            stateVersion = "24.05";
          };

          programs.home-manager.enable = true;
        };
        backupFileExtension = "homebackup";
        useGlobalPkgs = true;
        useUserPackages = true;
      };

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Enable networking
      networking.networkmanager.enable = true;

      # Set your time zone.
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

      # Configure keymap in X11
      services.xserver = {
        layout = "us";
        xkbVariant = "";
      };

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # Enable sound with pipewire.
      hardware.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
      };

      # Enable touchpad support (enabled default in most desktopManager).
      services.xserver.libinput.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.froggi = {
        isNormalUser = true;
        description = "Avery";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      nix.settings = {
        substituters = [
          "https://cache.nixos.org/"
        ];

        max-jobs = "auto";
      };

      # Enable automatic login for the user.
      # services.xserver.displayManager.autoLogin.enable = true;
      # services.xserver.displayManager.autoLogin.user = "froggi";

      # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
      # systemd.services."getty@tty1".enable = false;
      # systemd.services."autovt@tty1".enable = false;

      # Install firefox.
      programs.firefox.enable = true;

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      programs.nh = {
        enable = true;
        flake = "/home/froggi/nix-flake";
        clean = {
          enable = true;
          extraArgs = "--keep-since 4d --keep 3";
        };
      };

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        git

        inputs.zen-browser.packages.${pkgs.system}.default
      ];

      fonts = {
        packages = with pkgs; [
          roboto-mono
          jetbrains-mono
          jost
          material-symbols
        ];
        fontDir.enable = true;
      };

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # List services that you want to enable:

      services.openssh.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "24.05"; # Did you read the comment?

    };
}
