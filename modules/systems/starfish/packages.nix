{ ... }:
{
  flake.nixosModules.starfishPackages =
    { inputs, pkgs, ... }:

    {
      imports = [
        inputs.horizon.nixosModules.default
      ];

      environment.systemPackages = with pkgs; [
        # Terminal Utilities.
        wget
        astroterm
        git
        gh
        direnv
        kew
        zip
        unzip
        btop
        superfile

        # Utilities.
        blueman
        kdePackages.plasma-browser-integration

        # Desktop.
        papirus-icon-theme
        rose-pine-cursor
        kdePackages.koi
        kdePackages.plasma-sdk
        kdePackages.plasma-workspace
        kdePackages.plasma-integration
        darkly
        glib
        dbus

        # Apps.
        obsidian
        vlc
        aseprite
        blockbench
        godot
        netcat
        arnis
        # For arnis
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good

        # Games.
        prismlauncher
        gamescope
        inputs.hytale-launcher.packages.${pkgs.system}.default
        pkg-config
        alsa-lib.dev
        udev.dev

        #(lutris.override {
        #  extraLibraries = pkgs: [
        # List library dependencies here
        #  ];
        #})
      ];

      fonts = {
        packages = with pkgs; [
          roboto
          jost
        ];
        fontDir.enable = true;
      };

      programs = {
        steam = {
          enable = true;
          remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
          dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
          localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
        };
        horizon.enable = true;

        zsh.enable = true;
      };

      services.flatpak.enable = true;
  
      environment.variables = {
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
          pkgs.alsa-lib
        ];
      };
    };
}
