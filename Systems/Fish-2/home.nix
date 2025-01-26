{ ... }:

{
  imports = [
  ];
  
  # user info
  home = {
    username = "avery";
    homeDirectory = "/home/avery";
    stateVersion = "23.11"; # Dont change this you dumbass avery.
  };

  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
      };
    };
  };

  programs.home-manager.enable = true;
}


