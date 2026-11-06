{ ... }:
{
  flake.nixosModules.discord =
    { inputs, ... }:

    {

      home-manager.sharedModules = [
        {
          imports = [
            inputs.nixcord.homeModules.nixcord
          ];

          programs.nixcord = {
            enable = true;
            #equibop.enable = false;
            discord.vencord.enable = true;
            vesktop.enable = true;
            config = {
              useQuickCss = true;
              frameless = true;
              plugins = {
                alwaysAnimate.enable = true;
                callTimer.enable = true;
                disableCallIdle.enable = true;
                webScreenShareFixes.enable = true;
                voiceDownload.enable = true;
                voiceMessages.enable = true;
                petpet.enable = true;
                messageLogger.enable = true;
                webRichPresence.enable = true;
              };
            };
            extraConfig = {
              # Some extra JSON config here
              # ...
            };
          };
        }
      ];

      /*
        xdg.desktopEntries = {
          nixcord = {
            name = "Nixcord";
            genericName = "Internet Messenger";
            exec = "vesktop %U";
            terminal = false;
            categories = [ "InstantMessaging" "Network" "Chat" ];
            mimeType = [ "Application" ];
            Icon = ./nixcord.png
          };
        };
      */
    };
}
