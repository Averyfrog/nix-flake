{ pkgs, ... }:

{
  home-manager.sharedModules = [
    {
      programs.kitty = {
        enable = true;
        settings = {
          enable_audio_bell = false;
          confirm_os_window_close = -0;

          font_family = "Roboto Mono";
          bold_font = "Roboto Mono Bold";
          italic_font = "Roboto Mono Italic";
          bold_italic_font = "Roboto Mono Bold Italic";
          font_size = "10";
          cursor_shape = "beam";
          cursor_trail = 3;
          cursor_trail_decay = "0.1 0.5";

          window_padding_width = 4;
        };

        extraConfig = ''
          include colors.conf
        '';
      };
    }
  ];

  programs.fish.enable = true;
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  fonts = {
    packages = with pkgs; [
      roboto-mono
    ];
  };
}
