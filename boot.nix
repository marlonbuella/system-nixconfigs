{ pkgs, lib, ... }:

{
    # imports = [
    #   # Include the results of the hardware scan.
    #   ./hardware-configuration.nix
    #   "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
    #   ./disk-config.nix
    # ];
    # boot.kernelPackages = let
    #   linux_wsl_pkg = { fetchurl, buildLinux, ... } @ args:

    #     buildLinux (args // rec {
    #       version = "6.6.36.6";
    #       modDirVersion = version;

    #       src = fetchurl {
    #         url = "https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/linux-msft-wsl-6.6.36.6.tar.gz";
    #         hash = "sha256-N9eu8BGtD/J1bj5ksMKWeTw6e74dtRd7WSmg5/wEmVs=";
    #       };

    #       kernelPatches = [
    #         {
    #           name = "Bcachefs support for Linux 6.6";
    #           patch = builtins.fetchpatch {
    #             url = "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=9e87705289667a6c5185c619ea32f3d39314eb1b";
    #             hash = "";
    #           };
    #           extraConfig = 
    #           # with lib.kernel; 
    #           {
    #             # CONFIG_BCACHEFS_FS = yes;
    #             # CONFIG_BCACHEFS_QUOTA = yes;
    #             # CONFIG_BCACHEFS_POSIX_ACL = yes;
    #           };
    #         }
    #       ];

    #       extraConfig = with builtins; (
    #         concatStringsSep "\n"
    #         [
    #           (
    #             replaceStrings
    #             [
    #               "="
    #               # "CONFIG_XFS_QUOTA"
    #               "CONFIG_BPF"
    #               "CONFIG_DEBUG_INFO_BTF"
    #             ]
    #             [
    #               " "
    #               # "# "
    #               "#  CONFIG_BPF"
    #               "# "
    #             ]
    #             (
    #               readFile (
    #                   fetchurl {
    #                       url = "https://github.com/microsoft/WSL2-Linux-Kernel/raw/refs/heads/linux-msft-wsl-6.6.y/arch/x86/configs/config-wsl";
    #                       hash = "sha256-8CHipQ4/B67cT2Wadd1y1jT35ZFErCVbRl8DAcap3FU=";
    #                   }
    #               )
    #             )
    #           )
    #           ''
    #             CONFIG_PAHOLE_HAS_BTF_TAG=n

    #             # CONFIG_BCACHEFS_FS=y
    #             # CONFIG_BCACHEFS_QUOTA=y
    #             # CONFIG_BCACHEFS_POSIX_ACL=y
    #           ''
    #         ]

    #       );

    #       ignoreConfigErrors = true;

    #       extraMeta.branch = "linux-msft-wsl-6.6.y";
    #     } // (args.argsOverride or {}));
    #   linux_wsl = pkgs.callPackage linux_wsl_pkg{};
    # in 
    #   pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_wsl);

    boot.supportedFilesystems = [
      # "bcachefs"
      "ext4"
      "btrfs"
    ];
}