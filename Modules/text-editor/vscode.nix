{ pkgs, ... }:

{
  home-manager.sharedModules = [
    {
      programs.vscode = {
        enable = true;
        mutableExtensionsDir = true;

        extensions = (with pkgs.vscode-extensions; [
          bbenoist.nix
          jnoortheen.nix-ide
          zainchen.json
          bierner.markdown-emoji
          bierner.emojisense
          #prince781.vala
          mesonbuild.mesonbuild
        ]);
        # Settings
        userSettings = {
          # General
          "window.menuBarVisibility" = "toggle";
          "workbench.activityBar.location" = "hidden";
          "editor.fontSize" = 10;
          "window.zoomLevel" = 0.5;
          "explorer.compactFolders" = false;
          "editor.cursorBlinking" = "smooth";
          "editor.cursorSmoothCaretAnimation" = "on";
          "workbench.list.smoothScrolling" = true;
          "editor.smoothScrolling" = true;
          "editor.tabSize" = 2;
      
          "nix.serverPath" = "nixd";
          "nix.enableLanguageServer" = true;
          "nixpkgs" = {
            "expr" = "import <nixpkgs> { }";
          };
          "formatting" = {
            "command" = "alejandra";
          };
        };
      };
    }
  ];
}
