{
  inputs = {
    baseflake.url = "../..";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "baseflake/nixpkgs";
    };
  };

  outputs = { self, baseflake, nixos-generators, ... }: {
    nixosModules.default.imports = [ ./. ];

    nixosConfigurations.default = baseflake.nixosConfigurations.default.extendModules {
        specialArgs = {
            nixosGenerators = nixos-generators;
        };

        modules = [ self.nixosModules.default ];
    };
  };
}