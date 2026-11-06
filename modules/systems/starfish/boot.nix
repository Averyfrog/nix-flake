{
  ...
}:

{
  flake.nixosModules.starfishBoot =
    {
      pkgs,
      config,
      ...
    }:
    {
      boot = {
        loader = {
          efi = {
            canTouchEfiVariables = true;
          };
          grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";
          };
        };

        plymouth = {
          enable = true;
          theme = "blahaj";
          themePackages = with pkgs; [
            # By default we would install all themes
            (adi1090x-plymouth-themes.override {
              selected_themes = [ "loader_2" ];
            })
            nixos-bgrt-plymouth
            plymouth-blahaj-theme
          ];
        };

        # Use latest kernel.
        kernelPackages = pkgs.linuxPackages;

        # Enable "Silent boot"
        consoleLogLevel = 0;
        initrd.kernelModules = [ "amdgpu" ];

        extraModulePackages = with config.boot.kernelPackages; [ yt6801 ];
        kernelParams = [
          "acpi.ec_no_wakeup=1" # Fixes ACPI wakeup issues
          "amdgpu.dcdebugmask=0x400" # Fixes Wayland slowdowns/freezes

          # For Plymouth
          "quiet"
          "splash"
          #"boot.shell_on_fail"
          #"udev.log_priority=3"
          #"rd.systemd.show_status=auto"

        ];

        # Hide the OS choice for bootloaders.
        # It's still possible to open the bootloader list by pressing any key
        # It will just not appear on screen unless a key is pressed
        loader.timeout = 0;
      };

      environment.variables = {
        AMD_VULKAN_IXD = "RADV";
      };

      hardware = {
        tuxedo-drivers.enable = true;
        tuxedo-control-center.enable = true;
      };

      nixpkgs.overlays = [
        (final: prev: {
          linuxPackages = prev.linuxPackages.extend (
            lFinal: lPrev: {
              tuxedo-drivers = lPrev.tuxedo-drivers.overrideAttrs (oldAttrs: {
                makeFlags = (oldAttrs.makeFlags or [ ]) ++ [ "cmd_sign=" ];

                # Handles both uncompressed (.ko) and compressed (.ko.xz / .ko.zst) modules
                postInstall = (oldAttrs.postInstall or "") + ''
                  find $out -type f -name "*.ko*" | while read -r file; do
                    base_ko=$(echo "$file" | sed -E 's/\.(xz|zst|gz)$//')
                    touch "''${base_ko}.cer"
                  done
                '';
              });
            }
          );

          linuxPackages_latest = prev.linuxPackages_latest.extend (
            lFinal: lPrev: {
              tuxedo-drivers = lPrev.tuxedo-drivers.overrideAttrs (oldAttrs: {
                makeFlags = (oldAttrs.makeFlags or [ ]) ++ [ "cmd_sign=" ];
                postInstall = (oldAttrs.postInstall or "") + ''
                  find $out -type f -name "*.ko*" | while read -r file; do
                    base_ko=$(echo "$file" | sed -E 's/\.(xz|zst|gz)$//')
                    touch "''${base_ko}.cer"
                  done
                '';
              });
            }
          );
        })
      ];

      # Let tuxedo control center manage power.
      services.power-profiles-daemon.enable = false;
      services.upower.enable = true;

      services.tlp = {
        enable = true;
        pd.enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 20;

          #Optional helps save long term battery health
          #START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
          #STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
        };
      };

      # Prevent keyboard not working after sleep mode.
      powerManagement.resumeCommands = "${pkgs.kmod}/bin/rmmod atkbd; ${pkgs.kmod}/bin/modprobe atkbd reset=1";

    };
}
