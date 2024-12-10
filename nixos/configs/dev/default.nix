{ modulesPath, pkgs, ... }:

{
    # NixOS config with enabled accounts and tools for debugging

    disabledModules = [
        # Need to disable headless profile for debugging (i.e. access serial consoles)
        "${modulesPath}/profiles/headless.nix"
    ];

    nix.settings = {
        # Enable Nix commands and Flakes
        experimental-features = [ "nix-command" "flakes" ];
    };

    # use safe version of Sudo and enable wheel users to execute it without password
    security.sudo-rs = {
        enable = true;
        execWheelOnly = true;
        wheelNeedsPassword = false;
    };
}