{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    prismlauncher
    superTuxKart
    dolphin-emu
  ];
}
