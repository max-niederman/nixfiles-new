{ config, pkgs, lib, ... }:

{
  config = {
    virtualisation.podman = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    virtualisation.libvirtd = {
      enable = true;
    };

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    services.ollama = {
      enable = true;
    };

    environment.systemPackages = [
      config.services.ollama.package
      config.boot.kernelPackages.perf
    ];
  };
}
