{ inputs, ... }:

{
  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  programs.nixcord = {
    enable = true;
    quickCss = ''@import url("https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/flavors/catppuccin-mocha.theme.css");'';  # quickCSS file
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