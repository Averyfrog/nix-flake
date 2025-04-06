/*
 ___           _   
| _ ) ___  ___| |_ 
| _ \/ _ \/ _ \  _|
|___/\___/\___/\__|

*/
{ pkgs, ... }:

{
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
      systemd-boot.consoleMode = "max";
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
    initrd.systemd.enable = true;

    # Loading screen theme.
    plymouth = {
      enable = true;
      themePackages = [
        pkgs.catppuccin-plymouth
      ];
      theme = "catppuccin-macchiato";
    };

  };

  console = {
    colors = [
      "1e1e2e" # base
      "181825" # mantle
      "313244" # surface0
      "45475a" # surface1
      "585b70" # surface2
      "cdd6f4" # text
      "f5e0dc" # rosewater
      "b4befe" # lavender
      "f38ba8" # red
      "fab387" # peach
      "f9e2af" # yellow
      "a6e3a1" # green
      "94e2d5" # teal
      "89b4fa" # blue
      "cba6f7" # mauve
      "f2cdcd" # flamingo
    ];
  };
}
