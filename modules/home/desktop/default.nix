{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./apps.nix ];

  config = {
    wayland.windowManager.hyprland = {
      enable = true;

      extraConfig = ''
        exec-once = ${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
        exec-once = fcitx5
        exec-once = ${pkgs.swaynotificationcenter}/bin/swaync
        exec-once = ${pkgs.swayosd}/bin/swayosd-server
        exec-once = waypaper --restore --backend swww

        env = GTK_IM_MODULE,fcitx
        env = QT_IM_MODULE,fcitx
        env = XMODIFIERS,@im=fcitx

        env = HYPRCURSOR_THEME,${config.home.pointerCursor.name}
        env = HYPRCURSOR_SIZE,${toString config.home.pointerCursor.size}

        input {
          kb_layout  = us
          kb_variant = altgr-intl

          follow_mouse = 1

          touchpad {
            natural_scroll = true
          }
        }

        gestures {
          workspace_swipe = true
        }

        general {
          gaps_out = 25
          gaps_in = 10

          border_size = 0
        }

        cursor {
          no_warps = true
        }

        decoration {
          rounding = 8
        }

        misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
        }

        animations {
          enabled = false
        }

        $mainMod = SUPER

        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow

        bind = $mainMod, W, killactive
        bind = $mainMod, M, fullscreen

        bind = $mainMod, Space,  exec, fuzzel
        bind = $mainMod, Return, exec, alacritty
        bind = $mainMod, U,      exec, firefox
        bind = $mainMod, C,      exec, code

        bind = ,         Print, exec, grim -g "$(slurp)" - | tee "$HOME/Pictures/Screenshots/$(date -Iseconds).png" | wl-copy --type image/png

        bind = $mainMod, Backspace, exec, wlogout

        ${lib.strings.concatMapStringsSep "\n" (
          n:
          let
            n' = builtins.toString n;
          in
          ''
            bind = $mainMod,       ${n'}, workspace, ${n'}
            bind = $mainMod SHIFT, ${n'}, movetoworkspacesilent, ${n'}
          ''
        ) (lib.lists.range 1 9)}

        bind = $mainMod,       [, workspace, r-1
        bind = $mainMod,       ], workspace, r+1
        bind = $mainMod SHIFT, [, movetoworkspacesilent, r-1
        bind = $mainMod SHIFT, ], movetoworkspacesilent, r+1

        bind = $mainMod,       H, movefocus, l
        bind = $mainMod,       J, movefocus, d
        bind = $mainMod,       K, movefocus, u
        bind = $mainMod,       L, movefocus, r
        bind = $mainMod SHIFT, H, movewindow, l
        bind = $mainMod SHIFT, J, movewindow, d
        bind = $mainMod SHIFT, K, movewindow, u
        bind = $mainMod SHIFT, L, movewindow, r

        bind = $mainMod,       S, togglefloating

        binde = , XF86AudioRaiseVolume,  exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume 5
        binde = , XF86AudioLowerVolume,  exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume -5
        binde = , XF86MonBrightnessUp,   exec, ${pkgs.brightnessctl}/bin/brightnessctl s +5%
        binde = , XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-
      '';
    };

    catppuccin.pointerCursor = {
      enable = true;
      accent = "dark";
    };
    home.pointerCursor = {
      size = 32;
      gtk.enable = true;
    };

    gtk = {
      enable = true;

      theme = {
        name = "Catppuccin-Macchiato-Standard-Blue-Dark";
        package = pkgs.catppuccin-gtk.override { variant = "macchiato"; };
      };

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override { flavor = "macchiato"; };
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    i18n.inputMethod.fcitx5.catppuccin.enable = true;

    home.file."Pictures/Wallpapers" = {
      source = ./wallpapers;
    };

    programs.fuzzel = {
      enable = true;
      catppuccin.enable = true;
      settings = {
        main = {
          prompt = "λ";
        };
      };
    };

    programs.wlogout = {
      enable = true;
      style = ''
        window {
          background-color: rgba(0, 0, 0, 0);
        }

        button {
          border-radius: 0;
          border-color: black;
          text-decoration-color: #cad3f5;
          color: #cad3f5;
          background-color: #24273a;
          border-style: solid;
          border-width: 1px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
        }

        button:focus, button:active {
          color: #24273a;
          background-color: #c6a0f6;
          outline-style: none;
        }

        #lock {
            background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/lock.png"));
        }

        #logout {
            background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/logout.png"));
        }

        #suspend {
            background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/suspend.png"));
        }

        #hibernate {
            background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/hibernate.png"));
        }

        #shutdown {
            background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/shutdown.png"));
        }

        #reboot {
            background-image: image(url("${config.programs.wlogout.package}/share/wlogout/icons/reboot.png"));
        }
      '';
    };

    programs.hyprlock = {
      enable = true;
      extraConfig = ''
        source = ${config.catppuccin.sources.hyprland}/themes/macchiato.conf

        $accent = $mauve
        $accentAlpha = $mauveAlpha
        $font = Iosevka Nerd Font

        # GENERAL
        general {
          disable_loading_bar = true
          hide_cursor = true
        }

        # BACKGROUND
        background {
          monitor =
          path = ${./wallpapers}/purple-night.png
          blur_passes = 0
          color = $base
        }

        # TIME
        label {
          monitor =
          text = cmd[update:30000] echo "$(date +"%R")"
          color = $text
          font_size = 90
          font_family = $font
          position = -30, 0
          halign = right
          valign = top
        }

        # DATE 
        label {
          monitor = 
          text = cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"
          color = $text
          font_size = 25
          font_family = $font
          position = -30, -150
          halign = right
          valign = top
        }

        # INPUT FIELD
        input-field {
          monitor =
          size = 300, 60
          outline_thickness = 4
          dots_size = 0.2
          dots_spacing = 0.2
          dots_center = true
          outer_color = $accent
          inner_color = $surface0
          font_color = $text
          fade_on_empty = false
          placeholder_text = <span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>
          hide_input = false
          check_color = $accent
          fail_color = $red
          fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
          capslock_color = $yellow
          position = 0, -35
          halign = center
          valign = center
        }
      '';
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${config.programs.hyprlock.package}/bin/hyprlock";
          before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
          after_sleep_cmd = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 300; # 5 minutes
            on-timeout = "${pkgs.libnotify}/bin/notify-send 'Idle' 'You have been idle for 5 minutes.'";
          }
          {
            timeout = 600; # 10 minutes
            on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
          }
          {
            timeout = 720; # 12 minutes
            on-timeout = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
            on-resume = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
          }
          {
            timeout = 1500; # 25 minutes
            on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };
    };

    home.packages = with pkgs; [
      wl-clipboard
      grim
      slurp
      hyprpicker
      swww
      waypaper
      pavucontrol
    ];
  };
}
