{ pkgs, ... }:

{
    # need git for development (ofc!)
    environment.systemPackages = [ pkgs.git ];

    # Enable Nix commands and Flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
}