/*
  ___           __ _                    _   _          
 / __|___ _ _  / _(_)__ _ _  _ _ _ __ _| |_(_)___ _ _  
| (__/ _ \ ' \|  _| / _` | || | '_/ _` |  _| / _ \ '  \ 
 \___\___/_||_|_| |_\__, |\_,_|_| \__,_|\__|_\___/_||_|
                    |___/                              

*/
{ config, pkgs, inputs, lib, ... }:

let
  #godot-beta = import ./Modules/NixOS/Godot/godot-beta.nix { inherit pkgs; };
in
{
  imports = [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
  ];

  home-manager = {
    # Pass inputs to home-manager modules.
    extraSpecialArgs = { inherit inputs; };
    users.avery = import ./home.nix;
    backupFileExtension =  "fsaf";
    useGlobalPkgs = true;
    useUserPackages = true;
  };

/*
 ___           _   
| _ ) ___  ___| |_ 
| _ \/ _ \/ _ \  _|
|___/\___/\___/\__|

*/

  boot = {

    # Kernel shit i dont understand.
    kernelPackages = pkgs.linuxPackages;
    kernelParams = ["quiet"
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    ];

    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
    initrd.systemd.enable = true;

    # Loading screen theme.
    plymouth = {
      enable = true;
      /*themePackages = [
        pkgs.catppuccin-plymouth
      ];
      theme = "catppuccin-macchiato";*/
    };

  };



  networking.hostName = "Fish-2"; # Define your hostname.
  # networking.wireless.enable = true;


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

  programs.dconf.enable = true;
  programs.xfconf.enable = true;
  

  xdg.portal = {
    enable = true;
    #wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };

  # services.desktopManager.plasma6.enable = true;

#wayland.windowManager.hyprland.plugins = [
#  inputs.hyprland-plugins.packages.${pkgs.system}.hycov
#  "/absolute/path/to/plugin.so"
#];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  console.keyMap = "uk";

  services.displayManager.sddm = lib.mkForce {
    enable = true;
    theme = "catppuccin-mocha";
    package = pkgs.kdePackages.sddm;
  };

  services = {

    xserver = {
      enable = true;
      xkb.layout = "gb";
      xkb.variant = "";
    };

    printing.enable = true;

    blueman.enable = true;

    flatpak.enable = true;

    gvfs.enable = true;

    # Audio.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
  };

  };
  # Configure console keymap

  hardware = {
    # Bluetooth.
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
      powerOnBoot = true;
    };

  };
  

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.avery = {
    isNormalUser = true;
    description = "Avery";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [
    ];
  };

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
  
    "electron-25.9.0"
    "electron-27.3.11"
    "python-2.7.18.8"
    "dotnet-runtime-7.0.20"
    "dotnet-runtime-wrapped-7.0.20"
    "dotnet-runtime-6.0.36"
    "dotnet-sdk-wrapped-6.0.428"
    "dotnet-sdk-6.0.428"

  ];

  programs = {
    
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

    builders-use-substitutes = true;
    extra-substituters = [
        "https://anyrun.cachix.org"
    ];

    extra-trusted-public-keys = [
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };

  nix.settings = {
    #substituters = ["https://hyprland.cachix.org"];
    #trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/avery/AbrNix";
  };

  programs.nix-ld.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    firefox
    git
    gnome-2048
    adwsteamgtk

    ascii-image-converter
    neofetch
    nitch
    cbonsai
    fish
    bash
    starship
    sl
    libsForQt5.qt5ct
    blueman
    sqlite
    wlr-protocols
    ytmdesktop

    swww
    waybar
    libsForQt5.dolphin
    nwg-look
    grim
    slurp
    swaynotificationcenter
    libnotify
    killall
    monitor
    xorg.xkill
    obs-studio
    gparted
    vintagestory

    obsidian
    aseprite
    lutris
    prismlauncher
    alvr
    appimage-run
    wine
    winetricks
    scarab
    everest-mons

    libsForQt5.qtstyleplugins
    libsForQt5.qtquickcontrols2
    libsForQt5.qtgraphicaleffects
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.lightly
    lightly-qt
    lxqt.lxqt-policykit
    openrgb-with-all-plugins
    glfw-wayland
    direnv
    nautilus
    gnome-photos
    gnome-software
    rxvt-unicode
    pavucontrol
    overskride
    wl-clipboard
    cliphist
    imagemagick
    xsettingsd

    hyprlock
    hyprpicker
    xwayland
    inputs.pyprland.packages.${system}.pyprland

    pipes
    gh-screensaver
    wf-recorder
    pamixer

    arrpc

    mesa
    nvidia-vaapi-driver
    vulkan-tools

    godot_4

    logseq

    openssl
    nixd
    alejandra

    inputs.astal.packages.${system}.io
    inputs.astal.packages.${pkgs.system}.notifd
    (callPackage ./../../Modules/NixOS/Astal/config { inherit inputs; })

    (catppuccin-sddm.override {
      flavor = "mocha";
      font  = "Noto Sans";
      fontSize = "9";
      #background = "${./wallpaper.png}";
      loginBackground = true;
    })

  ] ++ [
  ];

  services.udev = {
    enable = true;
    extraRules = builtins.fetchurl { # Makes OpenRGB work!
      url = "https://openrgb.org/releases/release_0.9/60-openrgb.rules";
      sha256 = "sha256:0f5bmz0q8gs26mhy4m55gvbvcyvd7c0bf92aal4dsyg9n7lyq6xp";
    }; 
  };

  nixpkgs.overlays = [ (final: prev: { # Makes vintagestory mouse work!
    vintagestory = prev.vintagestory.overrideAttrs (old: {
      preFixup = builtins.replaceStrings
        ["--prefix LD_LIBRARY_PATH"]
        ["--set LD_PRELOAD ${final.xorg.libXcursor}/lib/libXcursor.so.1 --prefix LD_LIBRARY_PATH"]
        old.preFixup;
    });
    
  })];

  fonts = {
    packages = with pkgs; [
      roboto-mono
      jetbrains-mono
      jost
      noto-fonts-emoji
      noto-fonts-emoji-blob-bin
      meslo-lgs-nf
      material-symbols
    ];
    fontDir.enable = true;
  };
  
  nixpkgs.config.qt5 = {
    enable = true;
    platformTheme = "qt5ct";
    /* style = {
      package = pkgs.utterly-nord-plasma;
      name = "Utterly Nord Plasma";
    }; */
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.nixvim = {
    enable = true;

    colorschemes.gruvbox.enable = true;
    
    globalOpts = {
      number = true;

      shiftwidth = 2;
    };

    plugins = {
      lualine.enable = true;
      rustaceanvim.rustAnalyzerPackage.enable = true;     
      treesitter.enable = true;
    };
  };


  #system.replaceRuntimeDependencies = [
  #  ({ original = pkgs.mesa; replacement = (import /srv/nixpkgs-mesa { }).pkgs.mesa; })
  #  ({ original = pkgs.mesa.drivers; replacement = (import /srv/nixpkgs-mesa { }).pkgs.mesa.drivers; })
  #];
  

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    /*package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "560.28.03";
      sha256_64bit = "sha256-martv18vngYBJw1IFUCAaYr+uc65KtlHAMdLMdtQJ+Y=";
      sha256_aarch64 = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
      openSha256 = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
      settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
      persistencedSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
    };*/
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;	
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  networking.firewall.allowedUDPPorts = [ 9943 9944 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
