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

  home-manager.sharedModules = [
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        systemd.variables = ["--all"];
        # set the flake package
        #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

        extraConfig = builtins.readFile ./hyprland-elements/hyprland-extra-config.conf;

        plugins = [
          #inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
          # ...
        ];
      };  
    }
  ];
  
  environment.systemPackages = with pkgs; [
    inputs.pyprland.packages.${pkgs.system}.pyprland
    
    inputs.astal.packages.${pkgs.system}.io
    inputs.astal.packages.${pkgs.system}.notifd
    (callPackage ./hyprland-elements/desktop-shell { inherit inputs; })
    uwsm
  ];
}
