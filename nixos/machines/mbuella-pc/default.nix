{ pkgs, ... }:

let
    config = import ./config.nix;
in
{
    # NixOS config for mbuella pc

    networking.hostName = "mbuella-pc";

    # for podman/buildah
    virtualisation.containers.enable = true;

    users.users = with config; {
      # default nonroot user
      "${defaultUserName}" = {
          uid = defaultUserId;
          isNormalUser = true;
          home = "/home/${defaultUserName}";
          createHome = true;
          extraGroups = [ "wheel" ];

          packages = with pkgs; [
            # net tools
            wget

            # editors
            vim

            # debugging containers
            buildah
            podman

            # packages to play
            hello
            cowsay
          ];

          # Start systemd user dbus on boot
          linger = true;
      };
    };
}