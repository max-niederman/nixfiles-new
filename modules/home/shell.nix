{ pkgs, ... }:

{
  config = {
    programs.nushell = {
      enable = true;
      configFile.text = ''
        $env.config = {
            show_banner: false,
            completions: {
                case_sensitive: false,
                quick: true,
                partial: true,
                algorithm: 'fuzzy',
            }
        }
      '';
    };

    programs.bash = {
      enable = true;
    };

    programs.starship = {
      enable = true;

      enableNushellIntegration = true;
      enableBashIntegration = true;

      settings = {
        shell.disabled = false;

        aws.disabled = true;
        azure.disabled = true;
        gcloud.disabled = true;

        character = {
          success_symbol = "[λ](bold green)";
          error_symbol = "[λ](bold red)";
          vicmd_symbol = "[λ](bold yellow)";
        };
      };
    };

    programs.wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require 'wezterm'

        local config = wezterm.config_builder()

        config.default_prog = { "/run/current-system/sw/bin/nu" }

        config.enable_wayland = false

        config.hide_tab_bar_if_only_one_tab = true

        config.font = wezterm.font 'FiraCode Nerd Font'
        config.color_scheme = 'Catppuccin Macchiato'

        return config
      '';
    };

    programs.carapace = {
      enable = true;
    };

    programs.zoxide = {
      enable = true;
    };

    home.packages = with pkgs; [
      # fetch
      neofetch

      # resource monitor
      htop
      iftop

      # network utilities
      iputils
      dogdns
      nmap
      caddy
      mtr

      # misc. utilities
      ripgrep
      file
      libtree
    ];
  };
}
