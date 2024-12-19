{ ... }:

{
  programs.kitty = {
    enable = true;
    #theme = "Catppuccin-Mocha";
    settings = {
      enable_audio_bell = false;
      confirm_os_window_close = -0;

      font_family = "Roboto Mono";
      bold_font = "Roboto Mono Bold";
      italic_font = "Roboto Mono Italic";
      bold_italic_font = "Roboto Mono Bold Italic";
      font_size = "10";
      cursor_shape = "beam";

      window_padding_width = 4;
    };

    extraConfig = ''
      include colors.conf
    '';
  };
}