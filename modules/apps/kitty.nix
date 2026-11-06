{ ... }:
{

  flake.nixosModules.kitty =
    { ... }:

    {
      home-manager.sharedModules = [
        {
          programs.kitty = {
            enable = true;
            settings = {
              enable_audio_bell = false;
              confirm_os_window_close = -0;

              font_family = "Lilex";
              bold_font = "Lilex Bold";
              italic_font = "Lilex Italic";
              bold_italic_font = "Lilex Italic";
              font_size = "10";
              cursor_shape = "beam";
              cursor_trail = 3;
              cursor_trail_decay = "0.1 0.5";

              window_padding_width = 8;

              background_opacity = 0.95;
            };

          # For matugen
            extraConfig = ''
              include colors.conf
            '';
          };
        }
      ];
    };
}
