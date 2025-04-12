{ pkgs, inputs, system, ... }:

{
  imports = [
    ./hyprland-elements/Anyrun/anyrun.nix
    ./hyprland-elements/gtk.nix
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.variables.XCURSOR_SIZE = "10";

  home-manager.sharedModules = [
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        systemd.variables = ["--all"];
        # set the flake package
        #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        
        settings = {
          "$mod" = "SUPER";

          bind = [
            "$mod, S, exec, ~/.config/hypr/scripts/screenshot.sh"
          ];
        };

        extraConfig = builtins.readFile ./hyprland-elements/hyprland-extra-config.conf;

        plugins = [
          #inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
          # ...
        ];
      };  

      home.file.".config/hypr/scripts" = {
        source = ./hyprland-elements/scripts;
        recursive = true;
      };
    }
  ];
  
  environment.systemPackages = with pkgs; [
    inputs.star-shell.packages.${pkgs.system}.default

    inputs.pyprland.packages.${pkgs.system}.pyprland
    
    inputs.astal.packages.${pkgs.system}.io
    inputs.astal.packages.${pkgs.system}.notifd
  ];
}
