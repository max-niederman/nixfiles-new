{ config, pkgs, lib, ... }:

{
  config = {
    programs.nushell = {
      enable = true;
      configFile.text = ''
        let carapace_completer = { |spans| carapace $spans.0 nushell $spans | from json }

        let-env config = {
          show_banner: false
          completions: {
            external: {
              enable: true
              completer: $carapace_completer
            }
          }
        }
      '';
    };

    programs.fish = {
      enable = true;

      plugins = map
        (p: {
          name = lib.strings.removePrefix "fishplugin-" p.name;
          src = p.src;
        })
        (with pkgs.fishPlugins; [
          pisces
          z
          sponge
          colored-man-pages
        ]);
    };

    programs.bash = {
      enable = true;
    };

    programs.starship = {
      enable = true;

      enableNushellIntegration = true;
      enableFishIntegration = true;
      enableBashIntegration = true;

      settings = {
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

    programs.kitty = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font";
      };
    };

    home.packages = with pkgs; [
      carapace
    ];
  };
}
