{ inputs, ... }:

{
  imports = [
    inputs.nvf.nixosModules.default
  ];

  programs.nvf = {
    enable = true;  
    
    settings = {
      vim = {
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        
        preventJunkFiles = true;

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };

        mini = {
          pairs.enable = true;
          icons.enable = true;
        };
        
        dashboard.alpha = {
          enable = true;
        };

        visuals = {
          rainbow-delimiters.enable = true;
        };

        options = {
         tabstop = 2;
          shiftwidth = 2;
        };

        languages = {
          enableLSP = true;
          enableTreesitter = true;

          nix.enable = true;
          ts.enable = true;
          rust.enable = true;
        };

        keymaps = [
          {
            key = "ff";
            mode = ["n"];
            action = ":Telescope find_files <ENTER>";
            silent = true;
            desc = "Opens file finder";
          }
        ];
      };
    };
  };
}
