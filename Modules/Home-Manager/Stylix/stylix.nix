{ config, pkgs, ... }:

let
  #colorscheme = ./colorschemes/pink-blossom.yaml;
in
{
  stylix = {
    enable = true;
    #image = ./image.jpg; # HAS to be set for some reason?

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    #base16Scheme = colorscheme;

    polarity = "dark";

    targets = {
      gtk.enable = true;
      firefox.enable = false;
      firefox.profileNames = [ "default" ];
      gnome.enable = false;
      nixvim.enable = false;
      fish.enable = false;
      hyprland.enable = false;
      hyprpaper.enable = false;
    };

    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 20;
    };
      
    fonts = {

      sansSerif = {
        name = "Jost*, Book";
        package = pkgs.jost;
      };

      serif = {
        name = "Jost*, Book";
        package = pkgs.jost;
      };

      monospace = {
        name = "MesloLGS NF";
        package = pkgs.meslo-lgs-nf;
      };

      sizes = {
        desktop = 10;
        popups = 10;
        applications = 10;
        terminal = 10;
      };
    };
  };

  home.file = {
    "colors/colors.css" = {
      text = ''
      :root {
          --base00: #${config.lib.stylix.colors.base00}; /* base     */
          --base01: #${config.lib.stylix.colors.base01}; /* mantle   */
          --base02: #${config.lib.stylix.colors.base02}; /* surface0 */
          --base03: #${config.lib.stylix.colors.base03}; /* surface1 */
          --base04: #${config.lib.stylix.colors.base04}; /* surface2 */
          --base05: #${config.lib.stylix.colors.base05}; /* text     */
          --base06: #${config.lib.stylix.colors.base06}; /* rosewater*/
          --base07: #${config.lib.stylix.colors.base07}; /* lavender */
          --base08: #${config.lib.stylix.colors.base08}; /* red      */
          --base09: #${config.lib.stylix.colors.base09}; /* peach    */
          --base0A: #${config.lib.stylix.colors.base0A}; /* yellow   */
          --base0B: #${config.lib.stylix.colors.base0B}; /* green    */
          --base0C: #${config.lib.stylix.colors.base0C}; /* teal     */
          --base0D: #${config.lib.stylix.colors.base0D}; /* blue     */
          --base0E: #${config.lib.stylix.colors.base0E}; /* mauve    */
          --base0F: #${config.lib.stylix.colors.base0F}; /* flamingo */
      }
      '';
    };
    "colors/colors-gtk.css" = {
      text = ''
      @define-color base00 #${config.lib.stylix.colors.base00}; /* base     */
      @define-color base01 #${config.lib.stylix.colors.base01}; /* mantle   */
      @define-color base02 #${config.lib.stylix.colors.base02}; /* surface0 */
      @define-color base03 #${config.lib.stylix.colors.base03}; /* surface1 */
      @define-color base04 #${config.lib.stylix.colors.base04}; /* surface2 */
      @define-color base05 #${config.lib.stylix.colors.base05}; /* text     */
      @define-color base06 #${config.lib.stylix.colors.base06}; /* rosewater*/
      @define-color base07 #${config.lib.stylix.colors.base07}; /* lavender */
      @define-color base08 #${config.lib.stylix.colors.base08}; /* red      */
      @define-color base09 #${config.lib.stylix.colors.base09}; /* peach    */
      @define-color base0A #${config.lib.stylix.colors.base0A}; /* yellow   */
      @define-color base0B #${config.lib.stylix.colors.base0B}; /* green    */
      @define-color base0C #${config.lib.stylix.colors.base0C}; /* teal     */
      @define-color base0D #${config.lib.stylix.colors.base0D}; /* blue     */
      @define-color base0E #${config.lib.stylix.colors.base0E}; /* mauve    */
      @define-color base0F #${config.lib.stylix.colors.base0F}; /* flamingo */
      '';
    };
    "colors/colors.scss" = {
      text = ''
          $base00: #${config.lib.stylix.colors.base00}; /* base     */
          $base01: #${config.lib.stylix.colors.base01}; /* mantle   */
          $base02: #${config.lib.stylix.colors.base02}; /* surface0 */
          $base03: #${config.lib.stylix.colors.base03}; /* surface1 */
          $base04: #${config.lib.stylix.colors.base04}; /* surface2 */
          $base05: #${config.lib.stylix.colors.base05}; /* text     */
          $base06: #${config.lib.stylix.colors.base06}; /* rosewater*/
          $base07: #${config.lib.stylix.colors.base07}; /* lavender */
          $base08: #${config.lib.stylix.colors.base08}; /* red      */
          $base09: #${config.lib.stylix.colors.base09}; /* peach    */
          $base0A: #${config.lib.stylix.colors.base0A}; /* yellow   */
          $base0B: #${config.lib.stylix.colors.base0B}; /* green    */
          $base0C: #${config.lib.stylix.colors.base0C}; /* teal     */
          $base0D: #${config.lib.stylix.colors.base0D}; /* blue     */
          $base0E: #${config.lib.stylix.colors.base0E}; /* mauve    */
          $base0F: #${config.lib.stylix.colors.base0F}; /* flamingo */
      '';
    };
  };
}