{ ... }:

{
  flake.nixosModules.anomalocarisPackages = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      prismlauncher
      supertuxkart
      dolphin-emu
    ];
  };
}
