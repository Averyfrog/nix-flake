{ inputs, pkgs, ... }:

{
  
  home-manager.sharedModules = [
    {
      imports = [inputs.anyrun.homeManagerModules.default];

      programs.anyrun = {
        enable = true;
        config = {
          x = { fraction = 0.5; };
          y = { fraction = 0.3; };
          width = { absolute = 400; };
          hideIcons = false;
          ignoreExclusiveZones = false;
          layer = "overlay";
          hidePluginInfo = false;
          closeOnClick = false;
          showResultsImmediately = false;
          maxEntries = null;

          plugins = with inputs.anyrun.packages.${pkgs.system}; [
            # Plugins
            applications
            websearch
          ];

        };

        extraCss = /*css */ ''
          @import "./anyrun.css"
        '';
      };
    }
  ];
}
