{ ... }:
{
  flake.nixosModules.neovim =
    { inputs, pkgs, ... }:

    {
      imports = [
        inputs.nvf.nixosModules.default
      ];

      environment.systemPackages = with pkgs; [
        neovide
      ];
      programs.nvf = {
        enable = true;

        settings = {
          vim = {
            statusline.lualine.enable = true;
            telescope.enable = true;
            autocomplete.nvim-cmp.enable = true;
            treesitter.enable = true;

            preventJunkFiles = true;

            diagnostics = {
              enable = true;
              config = {
                virtual_lines = true;
                virtual_text = true;
              };
            };

            theme = {
              enable = true;
              transparent = true;
              name = "rose-pine";
              style = "moon";
            };

            mini = {
              pairs.enable = true;
              icons.enable = true;
              tabline.enable = true;
              #indentscope.enable = true;
            };

            dashboard = {
              alpha.enable = true;
            };

            visuals = {
              rainbow-delimiters.enable = true;
            };

            ui = {
              nvim-highlight-colors = {
                enable = true;
                setupOpts = {
                  render = "virtual";
                  virtual_symbol = "■";
                };
              };
            };

            options = {
              #termguicolors = false;
              tabstop = 2;
              shiftwidth = 2;
            };

            lsp = {
              enable = true;
              trouble.enable = true;
            };

            languages = {
              enableTreesitter = true;

              nix.enable = true;
              php.enable = true;
              rust.enable = true;
              wgsl.enable = true;
              csharp.enable = true;
              css.enable = true;
              qml.enable = true;
            };

            keymaps = [
              {
                key = "ff";
                mode = [ "n" ];
                action = ":Telescope find_files <ENTER>";
                silent = true;
                desc = "Opens file finder";
              }
            ];

            extraLuaFiles = [
              # ./neovim-extra.lua
            ];
          };
        };
      };
    };

}
