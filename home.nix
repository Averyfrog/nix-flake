{ inputs, config, pkgs, ... }:

{
  imports = [
    ./Modules/Home-Manager/starlessHome.nix
    inputs.nixcord.homeManagerModules.nixcord
    inputs.textfox.homeManagerModules.default
  ];
  
  # user info
  home = {
    username = "avery";
    homeDirectory = "/home/avery";
    stateVersion = "23.11"; # Dont change this you dumbass avery.
  };

  textfox = {
    enable = false;
    profile = "default";
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


