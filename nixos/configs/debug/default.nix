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

    # Break-glass user account (disabled by default)
    users.users.debugger = {
        uid = 33101;
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        hashedPassword = "$y$j9T$ZiMP/kXfKuSh76mrM/pAh/$vsNprLqY4RtznnK9C6HZs4a8Dk5YqlYeZdyN8L36EE8";

        # tools for debugging
        packages = with pkgs; [
            # net tools
            iputils
            iproute2
            wget

            # process tools
            procps

            # editors
            vim

            # debugging containers coz Y not?
            podman
        ];
    };
}