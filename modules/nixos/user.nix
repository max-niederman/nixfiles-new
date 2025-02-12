{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = {
    users = {
      mutableUsers = false;
      users.max = {
        isNormalUser = true;
        createHome = true;
        extraGroups = [
          "wheel"
          "video"
          "networkmanager"
          "dialout"
          "podman"
          "kvm"
          "libvirtd"
          "wireshark"
        ];

        hashedPasswordFile = config.sops.secrets."user/hashed_password".path;

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmdKg6WzEiyKysklc3YAKLjHEDLZq4RAjRYlSVbwHs9 max"
        ];
      };
    };

    sops.secrets."user/hashed_password".neededForUsers = true;

    environment.systemPackages = with pkgs; [ nushell ];

    security.sudo.wheelNeedsPassword = false;

    services.openssh.enable = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      sharedModules = [ ../home ];

      # if the user attribute is not present, home-manager won't activate
      users = lib.attrsets.genAttrs [ "max" ] (_: { });
    };
  };
}
