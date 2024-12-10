{
    # Debug is just extension of dev.

    imports = [
        ../dev
    ];
    
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