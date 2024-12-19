{ config, inputs, pkgs, ... }: 

let
  matugen_config = (pkgs.formats.toml {}).generate "matugen_config" {
    config = {};
    templates = {
      "gtk-4.0" = {
        input_path = "${config.xdg.configHome}/matugen/templates/gtk-colors.css";
        output_path = "~/.config/gtk-4.0/gtk-colors.css";
      };

      "gtk-3.0" = {
        input_path = "${config.xdg.configHome}/matugen/templates/gtk-colors.css";
        output_path = "~/.config/gtk-3.0/gtk-colors.css";
      };

      "kitty" = {
        input_path = "${config.xdg.configHome}/matugen/templates/kitty-colors.conf";
        output_path = "~/.config/kitty/colors.conf";
        post_hook = "kill -SIGUSR1 $(pgrep kitty)";
      };

      "cava" = {
        input_path = "${config.xdg.configHome}/matugen/templates/kitty-colors.conf";
        output_path = "~/.config/cava/colors.conf";
        post_hook = "kill -SIGUSR2 $(pgrep cava)";
      };
    };
  };
in {

  imports = [
    inputs.matugen.nixosModules.default
  ];
  
  home = {
    file.".config/matugen/config.toml".source = matugen_config;
    file.".config/matugen/templates" = {
      source = ./templates;
      recursive = true;
    };
    packages = [
      inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

  xdg.enable = true;
}