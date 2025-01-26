{ pkgs, ... }:

{
  home-manager.sharedModules = [
    {
      gtk = {
        enable = true;
        /*
        theme = {
          name = "catppuccin-mocha-yellow-compact";
          package = pkgs.catppuccin-gtk.override {
            accents = [ "yellow" ];
            size = "compact";
            #tweaks = [ "rimless" "black" ];
            variant = "mocha";
          };
        };
        */

        theme = {
          package = pkgs.adw-gtk3;
          name = "adw-gtk3";
        };

        iconTheme = {
          
          package = pkgs.catppuccin-papirus-folders.override {
            flavor = "mocha";
            accent = "yellow";
          };
          name = "Papirus-Dark";
          
          #package = pkgs.gruvbox-plus-icons;
          #name = "Gruvbox-Plus-Dark";
        };

        font = {
          name = "Jost*, Book";
          package = pkgs.jost;
          size = 10;
        };

        gtk4.extraConfig.gtk-decoration-layout = "";
        gtk3.extraConfig.gtk-decoration-layout = "";
        gtk4.extraConfig.gtk-enable-animations = "true";
        gtk3.extraConfig.gtk-enable-animations = "true";

        gtk3.extraCss = ''@import 'gtk-colors.css';'';
        gtk4.extraCss = ''@import 'gtk-colors.css';'';
      };

      home.sessionVariables.GTK_THEME = "adw-gtk3";

      home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 20;

        hyprcursor.enable = true;
        gtk.enable = true;
        x11.enable = true;
      };

      xdg.systemDirs.data = [
        "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
        "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      ];
    }
  ];
}
