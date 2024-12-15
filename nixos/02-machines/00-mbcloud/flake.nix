{
  inputs = {
    # @todo: change these urls to github ones once went live
    base.url = "git+file:///home/alonbuella/.src/projects/nix-mbuella-pc-wsl?dir=nixos.new/00-inputs/00-base";
    debug.url = "git+file:///home/alonbuella/.src/projects/nix-mbuella-pc-wsl?dir=nixos.new/00-inputs/01-debug";

    nixosGenerators.url = "../../01-modules/01-generators";
    nixosShell.url = "../../01-modules/00-shell";
  };

  outputs = { self, base, debug, nixosGenerators, nixosShell, ... }: {
    nixosModules.default.imports = [ ./. ];

    nixosConfigurations = {
        default = base.nixosConfigurations.default.extendModules {
            modules = [ self.nixosModules.default ];
        };
        debug = debug.nixosConfigurations.default.extendModules {
            modules = [
                nixosGenerators.nixosModules.default
                # nixosShell.nixosModules.default
                self.nixosModules.default
            ];
        };
    };
  };
}
