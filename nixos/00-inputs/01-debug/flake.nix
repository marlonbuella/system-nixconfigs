{
  inputs = {
    # base.url = "git+file:///home/alonbuella/.src/projects/nix-mbuella-pc-wsl?dir=nixos.new/00-inputs/00-base";
    base.url = "../00-base";
  };

  outputs = { self, base, ... }@inputs: base.outputs // {
    nixosModules.default.imports = [ ./. ];

    nixosConfigurations.default = base.nixosConfigurations.default.extendModules {
        modules = [ self.nixosModules.default ];
    };
  };
}