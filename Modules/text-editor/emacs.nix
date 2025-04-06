{ pkgs, ... }:

{
  home-manager.sharedModules = [
    {
      programs.emacs = {
        enable = true;
        package = pkgs.emacs-gtk;
      };
    }
  ];
}
