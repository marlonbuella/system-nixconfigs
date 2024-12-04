{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11-small";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosModules.default.imports = [ ./. ];

    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit nixpkgs;

        modulesPath = inputs.nixpkgs + "/nixos/modules";
      };
      modules = [ self.nixosModules.default ];
    };
  } // {
    templates = {
        machine = {
            path = ./templates/machine;
            description = "Base template for creating machines with sensible defaults.";
        };
    };
  };
}
