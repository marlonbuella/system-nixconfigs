{ nixosGenerators, config, pkgs, lib, modulesPath, ... }:

{
    imports = [
        nixosGenerators.nixosModules.all-formats
    ];

    # WSL format similar to lxc
    formatConfigs.wsl = { config, pkgs, ... }: {
        imports = [
            nixosGenerators.nixosModules.lxc
        ];

        system.build.tarball = lib.mkForce (pkgs.callPackage "${modulesPath}/../lib/make-system-tarball.nix" {
            storeContents = [
                {
                    object = config.system.build.toplevel;
                    symlink = "none";
                }
            ];
            contents = with pkgs; [
                # @todo: re-enable wsl.conf later
                # {
                #     source = config.system.build.toplevel + "/etc/wsl.conf";
                #     target = "/etc/wsl.conf";
                # }
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
        });
    };
}