{ defaultUserId, defaultUserName, pkgs, config, lib, modulesPath, ... }:

let
    nixos-generators = (
        builtins.getFlake "github:nix-community/nixos-generators/098e8b6ff72c86944a8d54b64ddd7b7e6635830a"
    );
in
{
    imports = [
        nixos-generators.nixosModules.all-formats
    ];

    # WSL format similar to lxc
    formatConfigs.wsl = { config, pkgs, ... }: {
        imports = [
            nixos-generators.nixosModules.lxc
        ];

        system.build.tarball = lib.mkForce (pkgs.callPackage "${modulesPath}/../lib/make-system-tarball.nix" {
            storeContents = [
                {
                    object = config.system.build.toplevel;
                    symlink = "none";
                }
            ];
            contents = with pkgs; [
                {
                    source = config.system.build.toplevel + "/etc/wsl.conf";
                    target = "/etc/wsl.conf";
                }
                {
                    source = config.system.build.toplevel + "/init";
                    target = "/sbin/init";
                }
                # WSL mounts need the mount binary even before the systemd is started
                {
                    source = "${mount}/bin/mount";
                    target = "/bin/mount";
                }
            ];

            # extraCommands = 
            # let
            #     defaultUserIdStr = builtins.toString defaultUserId;
            # in
            # pkgs.writeScript "post-build.sh" ''
            #   # we need to pre-create the .local user folder so that
            #   # the mounter (run as root) don't need to create it 
            #   mkdir -p home/${defaultUserName}/.local
            #   ${pkgs.coreutils}/bin/chown ${defaultUserIdStr}:100 home/${defaultUserName}/.local
            #   ls -la home/${defaultUserName} > home/${defaultUserName}/.logs
            # '';
        });
    };
}