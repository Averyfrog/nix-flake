{ inputs, ... }:

{
  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  programs.nixcord = {
    enable = true;
    quickCss = ''@import "/home/avery/.config/vesktop/settings/colors-discord.css";'';  # quickCSS file
    vesktop.enable = true;
    discord.enable = false;
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
        pinDMs.enable = true;
        messageLogger.enable = true;
        webRichPresence.enable = true;
      };
    };
    extraConfig = {
      # Some extra JSON config here
      # ...
    };
  };

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
}
