{ ... }:
# heheh cool funny music lights :33333
{
  
  home-manager.sharedModules = [
    {
      programs.cava = {
        enable = true;
        settings = {
          input.method = "pipewire";
          color = {

          gradient = 1;
      
          };
        };
      };
    }
  ];
}

