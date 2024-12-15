{ modulesPath, ... }:

{
    # Production-optimized NixOS config

    system.stateVersion = "24.11";

    imports = [
        "${modulesPath}/profiles/minimal.nix"
        "${modulesPath}/profiles/headless.nix"
    ];

    # Custom Nix settings
    nix.settings = {
        # Store auto optimize
        auto-optimise-store = true;

        # Allow other derivations' builds to access root filesystem via __noChroot attribute
        sandbox = "relaxed";
        trusted-users = [ "@admin" ];
    };

    networking.firewall.enable = true;

    time.timeZone = "Asia/Manila";
    i18n.defaultLocale = "en_US.UTF-8";
}