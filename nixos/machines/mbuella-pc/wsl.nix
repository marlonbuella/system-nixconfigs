{ lib, ... }:

let
    config = import ./config.nix;
in
{
    # NixOS config for mbuella pc specific for WSL

    # Disable boot kernel, WSL has own
    boot = {
        initrd.enable = false;
        kernel.enable = false;
        loader.grub.enable = false;
    };

    # disable services which causes issues in WSL
    networking.networkmanager.enable = false;
    networking.useDHCP = false;
    systemd.services = with lib; {
        "systemd-tmpfiles-setup.service".wantedBy = mkForce [];
        "systemd-tmpfiles-clean.timer".wantedBy = mkForce [];
        "systemd-tmpfiles-setup-dev-early.service".wantedBy = mkForce [];
        "systemd-tmpfiles-setup-dev.service".wantedBy = mkForce [];
    };
    environment.etc."resolv.conf".enable = false;

    # WSL-related file updates
    environment.etc."wsl.conf" = with config; {
        # Creates /etc/wsl.conf
        text = ''
            [boot]
            command="/sbin/init"
            systemd=true

            [user]
            default="${defaultUserName}"

            [automount]
            root="${defaultWslMountDir}"
        '';

        mode = "0400";
    };
}