{ ... }:

{
  flake.nixosModules.zen =
    {
      inputs,
      pkgs,
      ...
    }:
    {
      home-manager.sharedModules = [
        {
          imports = [
            inputs.zen-browser.homeModules.twilight
          ];

          programs.zen-browser = {
            enable = true;
            setAsDefaultBrowser = true;

            package = (
              inputs.zen-browser.packages."${pkgs.system}".twilight.override {
                nativeMessagingHosts = [ pkgs.firefoxpwa ];

                extraPrefsFiles = [
                  (builtins.fetchurl {
                    url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
                    sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
                  })
                ];
              }
            );

            profiles."bk1pznjq.Default Profile" = {
              id = 0;
              name = "zen-twighlight";
              isDefault = true;
            };
          };
        }
      ];
    };
}
