{ inputs, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    systemd.variables = ["--all"];
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    extraConfig = builtins.readFile ./config.conf;

    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      # ...
    ];
  };
   
}
