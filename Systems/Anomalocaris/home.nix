{ ... }:

{
  imports = [
  ];

  # User Info.
  home = {
    username = "froggi";
    homeDirectory = "/home/froggi";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
