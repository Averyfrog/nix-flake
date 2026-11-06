{ ... }:
{
  flake.nixosModules.hyprland =
    {
      inputs,
      pkgs,
      lib,
      ...
    }:

    let
      system = pkgs.stdenv.hostPlatform.system;
      lua = lib.generators.mkLuaInline;

      # Hyprland Lua bindings are generated as:
      # hl.bind(keys, dispatcher, flags)
      modKey = key: lua ''mod .. " + ${key}"'';

      bind = key: action: {
        _args = [
          (modKey key)
          (lua action)
        ];
      };

      bindPlain = key: action: {
        _args = [
          key
          (lua action)
        ];
      };

      /*
      bindWithFlags = key: action: flags: {
        _args = [
          (modKey key)
          (lua action)
          flags
        ];
      };
      */

      bindPlainWithFlags = key: action: flags: {
        _args = [
          key
          (lua action)
          flags
        ];
      };

      bindMouse = key: action: {
        _args = [
          (modKey key)
          (lua action)
          { mouse = true; }
        ];
      };

      exec = command: "hl.dsp.exec_cmd(${builtins.toJSON command})";

      bindExec = key: command:
        bind key (exec command);

      bindPlainExec = key: command:
        bindPlain key (exec command);

      workspaceBinds =
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
              key = "code:1${toString i}";
            in
            [
              {
                _args = [
                  (lua ''mod .. " + ${key}"'')
                  (lua "hl.dsp.focus({ workspace = ${toString ws} })")
                ];
              }
              {
                _args = [
                  (lua ''mod .. " + SHIFT + ${key}"'')
                  (lua "hl.dsp.window.move({ workspace = ${toString ws} })")
                ];
              }
            ]
          ) 6
        );

    in
    {
      programs.hyprland = {
        enable = true;

        # Keep these in sync if using a custom Hyprland flake.
        # package = inputs.hyprland.packages.${system}.hyprland;
        # portalPackage =
        #   inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
      };

      home-manager.sharedModules = [
        {
          wayland.windowManager.hyprland = {
            enable = true;
            configType = "lua";

            systemd.variables = [ "--all" ];

            settings = {
              # Lua variable declaration: local mod = "SUPER"
              mod = {
                _var = "SUPER";
              };

              # Hyprland configuration options are emitted through hl.config().
              config = {
                input = {
                  touchpad = {
                    natural_scroll = false;
                  };

                  sensitivity = 0.25;
                };

                general = {
                  snap = {
                    enabled = true;
                    border_overlap = true;
                    respect_gaps = true;
                  };
                };

                  #render = {
                  #  cm_enabled = false;
                  #};

                cursor = {
                  no_hardware_cursors = true;
                };
              };

              # Environment variables: hl.env(name, value)
              env = [
                {
                  _args = [ "QT_QPA_PLATFORM" "wayland" ];
                }
                {
                  _args = [ "QT_QPA_PLATFORMTHEME" "kde" ];
                }
                {
                  _args = [
                    "QML2_IMPORT_PATH"
                    "${pkgs.kdePackages.kirigami}/lib/${
                      builtins.replaceStrings
                        [ "full-" ]
                        [ "" ]
                        pkgs.qt5.qtbase.qtQmlPrefix
                    }/qml"
                  ];
                }
                {
                  _args = [ "GDK_SCALE" "1.25" ];
                }
              ];

              # Keybindings: every item generates hl.bind(...).
              bind =
                [
                  # Window management
                  (bind "B" ''hl.dsp.window.fullscreen({ action = "toggle" })'')
                  (bind "V" ''hl.dsp.window.float({ action = "toggle" })'')
                  (bind "M" "hl.dsp.exit()")
                  (bind "X" "hl.dsp.window.close()")

                  # Applications
                  (bindExec "T" "kitty zsh")
                  (bindExec "R" "anyrun")
                  (bindExec "Space" "vicinae toggle")

                  # Screenshots
                  (bindPlainExec "Print" "grimblast copy screen")
                  (bindExec "S" "grimblast copy area")

                  # Window focus
                  (bind "left" ''hl.dsp.focus({ direction = "l" })'')
                  (bind "right" ''hl.dsp.focus({ direction = "r" })'')
                  (bind "up" ''hl.dsp.focus({ direction = "u" })'')
                  (bind "down" ''hl.dsp.focus({ direction = "d" })'')

                  # Pin
                  (bind "P" ''hl.dsp.window.pin({ action = "toggle" })'')

                  # Media:
                  (bindPlainWithFlags "XF86AudioNext"
                    (exec "playerctl next")
                    { release = true; })
                  (bindPlainWithFlags "XF86AudioPrev"
                    (exec "playerctl prev")
                    { release = true; })
                  (bindPlainExec "XF86AudioNext" "playerctl position 5+")
                  (bindPlainExec "XF86AudioPrev" "playerctl position 5-")
                  (bindPlainExec "XF86AudioPlay" "playerctl play-pause")

                  # Mouse movement/resizing
                  (bindMouse "mouse:272" "hl.dsp.window.drag()")
                  (bindMouse "mouse:273" "hl.dsp.window.resize()")

                  # Volume
                  (bindPlainWithFlags "XF86AudioRaiseVolume"
                    (exec "pamixer -i 5")
                    { repeating = true; })
                  (bindPlainWithFlags "XF86AudioLowerVolume"
                    (exec "pamixer -d 5")
                    { repeating = true; })
                  (bindPlainExec "XF86AudioMute" "pamixer -t")

                  # Brightness
                  (bindPlainWithFlags "XF86MonBrightnessDown"
                    (exec "brightnessctl set 10%-")
                    { repeating = true; })
                  (bindPlainWithFlags "XF86MonBrightnessUp"
                    (exec "brightnessctl set 10%+")
                    { repeating = true; })
                ]
                ++ workspaceBinds;

              # Trackpad gestures.
              gesture = [
                {
                  fingers = 4;
                  direction = "up";
                  action = lua ''
                    function()
                      hl.exec_cmd("kitty")
                    end
                  '';
                }
                {
                  fingers = 4;
                  direction = "down";
                  action = lua ''
                    function()
                      hl.dsp.window.close()
                    end
                  '';
                }
                {
                  fingers = 4;
                  direction = "horizontal";
                  action = "workspace";
                  scale = 1.0;
                }
                {
                  fingers = 3;
                  direction = "pinchout";
                  action = "float";
                  mode = "float";
                }
                {
                  fingers = 3;
                  direction = "pinchin";
                  action = "float";
                  mode = "tile";
                }
                {
                  fingers = 3;
                  direction = "swipe";
                  mods = "CTRL";
                  action = "resize";
                  scale = 1.25;
                }
                {
                  fingers = 3;
                  direction = "swipe";
                  action = "move";
                  scale = 1.5;
                }
              ];

              curve = [
                {
                  _args = [
                    "easeInBack"
                    {
                      type = "bezier";
                      points = [
                        [ 0.44 (-0.17) ]
                        [ 0.81 (-0.17) ]
                      ];
                    }
                  ];
                }
                {
                  _args = [
                    "abezir"
                    {
                      type = "bezier";
                      points = [
                        [ 0.85 0.0 ]
                        [ 0.15 1.0 ]
                      ];
                    }
                  ];
                }
                {
                  _args = [
                    "overshoot"
                    {
                      type = "bezier";
                      points = [
                        [ 0.05 0.9 ]
                        [ 0.1 1.1 ]
                      ];
                    }
                  ];
                }
              ];

              animation = [
                {
                  leaf = "workspaces";
                  enabled = true;
                  speed = 4;
                  bezier = "abezir";
                  style = "slidefade 20%";
                }
                {
                  leaf = "windows";
                  enabled = true;
                  speed = 4;
                  bezier = "abezir";
                  style = "slide bottom 100%";
                }
                {
                  leaf = "windowsIn";
                  enabled = true;
                  speed = 4;
                  bezier = "overshoot";
                  style = "popin 40%";
                }
                {
                  leaf = "windowsOut";
                  enabled = true;
                  speed = 6;
                  bezier = "easeInBack";
                  style = "slide bottom 100%";
                }
                {
                  leaf = "windowsMove";
                  enabled = true;
                  speed = 2;
                  bezier = "abezir";
                  style = "popin";
                }
                {
                  leaf = "fadeOut";
                  enabled = true;
                  speed = 32;
                  bezier = "default";
                }
                {
                  leaf = "fadeIn";
                  enabled = true;
                  speed = 4;
                  bezier = "default";
                }
              ];

              window_rule = [
                {
                  match = {
                    class = "dev.zed.Zed";
                  };
                  opacity = "0.95";
                }
                {
                  match = {
                    class = "obsidian";
                  };
                  opacity = "0.95";
                }
                {
                  match = {
                    float = true;
                  };
                  border_size = 2;
                }
              ];

              layer_rule = [
                {
                  match = {
                    namespace = "vicinae";
                  };
                  blur = true;
                  ignore_alpha = 0.0;
                  no_anim = true;
                }
                {
                  match = {
                    namespace = "quickshell";
                  };
                  blur = true;
                  ignore_alpha = 0.5;
                  no_anim = true;
                }
              ];

              on = {
                _args = [
                  "hyprland.start"
                  (lua ''
                    function()
                      hl.exec_cmd("~/Projects/qualia-shell/scripts/startup.sh")
                      hl.exec_cmd("vicinae server")
                      hl.exec_cmd("awww-daemon")
                      hl.exec_cmd("arrpc")
                    end
                  '')
                ];
              };
            };

            extraConfig = ''
              require("theme")
            '';
          };
        }

        inputs.vicinae.homeManagerModules.default

        {
          programs.vicinae = {
            enable = true;

            systemd = {
              enable = true;
              autoStart = true;
            };
          };

          systemd.user.services.vicinae = {
            Service.EnvironmentFile = lib.mkForce [ ];
          };
        }
      ];

      nix.settings = {
        extra-substituters = [
          "https://vicinae.cachix.org"
        ];

        extra-trusted-public-keys = [
          "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        ];
      };

      environment.systemPackages = with pkgs; [
        grimblast
        killall
        awww

        inputs.quickshell.packages.${system}.default

        hyprpicker
        fyi
        hyprsysteminfo
        hyprpwcenter
        hyprpolkitagent

        kdePackages.qt6ct
        pavucontrol
        pamixer
        brightnessctl
        playerctl

        inputs.constellate.packages.${system}.default

        matugen
        arrpc
      ];

      fonts.packages = with pkgs; [
        material-symbols
      ];
    };
}
