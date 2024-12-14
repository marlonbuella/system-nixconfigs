{ lib, pkgs, ... }:

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

    # WSL-specific session vars
    environment.sessionVariables = with config;
    let
        wslWinpathsFile = import ../../packages/wsl-winpaths { inherit defaultWslMountDir pkgs; };
    in
    rec {
        PATH = [ "/bin" ] ++ (builtins.fromJSON (builtins.readFile "${wslWinpathsFile}"));
    };

    # Enable vscode server support for NixOS
    services.vscode-server.enable = true;
    # Install VSCode server's required binaries
    system.activationScripts.linkVscodeReqBinaries = with pkgs; ''
      ln -sf \
        ${coreutils}/bin/{uname,dirname,readlink} \
        /bin/
    '';
}