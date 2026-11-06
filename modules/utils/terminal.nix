{ ... }:
{

  flake.nixosModules.terminal =
    { pkgs, ... }:

    {
      home-manager.sharedModules = [
        {
          programs.zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;

            shellAliases = {
              ls = "eza --icons --color=always --group-directories-first";
              ll = "exa -alF --icons --color=always --group-directories-first";
              la = "exa -a --icons --color=always --group-directories-first";
              tree = "exa --tree --icons --color=always --group-directories-first";
              update = "nh os switch";
            };

            history.size = 10000;

            initContent = ''
              . "${pkgs.asdf-vm}/etc/profile.d/asdf-prepare.sh"
              autoload -Uz bashcompinit && bashcompinit
              . "${pkgs.asdf-vm}/share/bash-completion/completions/asdf.bash"
            '';
          };
        }
        {
          programs.zoxide = {
            enable = true;
            enableZshIntegration = true;
          };
        }
        {
          programs.direnv = {
            enable = true;
            enableZshIntegration = true;
            nix-direnv.enable = true;
          };
        }
      ];

      programs.zsh = {
        enable = true;
        enableBashCompletion = true;

        interactiveShellInit = ''
          nitch
        '';
        promptInit = ''
          ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
        '';
      };

      programs.starship = {
        enable = true;
      };

      environment.systemPackages = with pkgs; [
        cava
        nitch

        eza
      ];

      fonts = {
        packages = with pkgs; [
          roboto-mono
          nerd-fonts.iosevka-term
          lilex
        ];
      };
    };
}
