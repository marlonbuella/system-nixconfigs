{ isBuild, pkgs, config, lib, modulesPath, ... }:

let
    # isInNixos = (lib.strings.trim (builtins.readFile (import ./packages/utils/get-os-name.nix { inherit pkgs; }))) == "NixOS";
    isInNixos = true;
    defaultUserId = 1000;
    defaultUserName = "alonbuella";
    defaultMountDir = "/";
in
{
    imports = (if isBuild then [
        (import ./nixos-generator/formats.nix {
            inherit defaultUserId defaultUserName pkgs config lib modulesPath;
        })
    ] else []);

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

    # # WSL-specific packages
    # environment.systemPackages = with pkgs; [
    #     wslu
    # ];

    # WSL-related file updates
    environment.etc = {
        # Creates /etc/wsl.conf
        "wsl.conf" = {
            text = ''
                [boot]
                command="/sbin/init"
                systemd=true

                [user]
                default="${defaultUserName}"

                [automount]
                root="${defaultMountDir}"
            '';

            # mode = "0400";
        };
    };

    # # WSL-specific env vars
    # environment.variables = rec {
    #     PATH = [ "/bin" ];
    # };

    # WSL-specific session vars
    environment.sessionVariables = rec {
        PATH = [
            "/bin"
            (lib.mkIf (isInNixos)
                (builtins.readFile (import ./packages/generate-windows-paths
                    { inherit defaultMountDir pkgs; }
                ))
            )
        ];
        # # for debugging
        # TEST = (builtins.readFile (import ./packages/utils/get-os-name.nix { inherit pkgs; }));
    };

    # VSCode server customized for Nix
    # @todo: create a package/service for this
    system.userActivationScripts.linkCodeServerToNixBuild = 
    lib.mkIf (isInNixos) (
        let
            vscode-win-version-hash = lib.strings.trim (
                builtins.readFile (import ./packages/vscode-server-wsl/get-vscode-win-version-hash.nix { inherit pkgs lib; })
            );
            vscode-server-wsl = import ./packages/vscode-server-wsl { inherit pkgs lib; };
        in
        ''
            if [[ ! -h "$HOME/.vscode-server/bin/${vscode-win-version-hash}" ]]; then
                mkdir -p $HOME/.vscode-server/bin
                ln -s "${vscode-server-wsl}" "$HOME/.vscode-server/bin/${vscode-win-version-hash}"
            fi
        ''
    );
    
    # default nonroot user for WSL
    users.users.${defaultUserName} = {
        uid = defaultUserId;
        isNormalUser = true;
        home = "/home/${defaultUserName}";
        createHome = true;
        extraGroups = [ "wheel" ];

        packages = with pkgs; [
            buildah
            podman
            cowsay
        ];

        # Start systemd user dbus on boot
        linger = true;
    };
}
