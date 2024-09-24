{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    system.stateVersion = "23.11";

    boot.loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
        useOSProber = true;
      };
      timeout = 3;
    };

    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs.forceImportRoot = false;

    networking = {
      hostName = "tar-minyatur";
      hostId = "4d79803c";
      networkmanager.enable = true;
      firewall.enable = false;
    };

    time.timeZone = "America/Los_Angeles";

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      open = true;
      powerManagement.enable = true;
      modesetting.enable = true;
      nvidiaSettings = true;
    };

    services.ollama.acceleration = "cuda";

    home-manager.sharedModules = [{
      # use the state version of the system, from the **NixOS** config
      home.stateVersion = config.system.stateVersion;

      wayland.windowManager.hyprland = {
        settings.env = [
          "LIBVA_DRIVER_NAME=nvidia"
          "NIXOS_OZONE_WL=1"
          "WLR_NO_HARDWARE_CONFIG=1"
          "WLR_NO_HARDWARE_CURSORS=1"
        ];

        extraConfig = ''
          render {
            explicit_sync = 0
          }
        
          monitor = DP-2,     2560x1440@120, 0x0,    1
          monitor = DP-3,     2560x1440@144, 2560x0, 1

          workspace = 1, monitor:DP-2, default:true
          workspace = 2, monitor:DP-2
          workspace = 3, monitor:DP-2
          workspace = 4, monitor:DP-3, default:true
          workspace = 5, monitor:DP-3
          workspace = 6, monitor:DP-3
        '';
      };
    }];
  };
}
