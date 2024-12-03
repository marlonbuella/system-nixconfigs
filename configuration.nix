{ isBuild, pkgs, config, lib, modulesPath, ... }:

{
    system.stateVersion = "24.11";

    imports = [
        "${modulesPath}/profiles/base.nix"
        # ./hardware-configuration.nix
        ./filesystems.nix
        ./boot.nix
        (import ./wsl.nix { inherit isBuild pkgs config lib modulesPath; })
        ./dev.nix
    ];

    # Custom Nix settings
    nix.settings = {
        # Enable Nix commands and Flakes
        experimental-features = [ "nix-command" "flakes" ];

        # Store auto optimize
        auto-optimise-store = true;

        # Allow other derivations' builds to access root filesystem via __noChroot attribute
        sandbox = "relaxed";
        trusted-users = [ "@admin" ];
        # we need access to wsl conf file
        extra-sandbox-paths = [
            "/etc/wsl.conf"
        ];
    };

    networking.hostName = "mbuella-pc";
    networking.firewall.enable = true;

    time.timeZone = "Asia/Manila";
    i18n.defaultLocale = "en_US.UTF-8";
    
    # use safe version of Sudo and enable wheel users to execute it without password
    security.sudo-rs = {
        enable = true;
        execWheelOnly = true;
        wheelNeedsPassword = false;
    };

    environment.systemPackages = with pkgs; [
        # mount
        vim
        wget
        git
    ];
}