{
  inputs = {
    baseflake.url = "../..";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "baseflake/nixpkgs";
    };
  };

  outputs = { self, baseflake, nixos-generators, ... }: baseflake.outputs // {
    nixosModules.default.imports = [ ./. ];

    nixosConfigurations.default = baseflake.nixosConfigurations.default.extendModules {
        specialArgs = {
            nixosGenerators = nixos-generators;
            additionalTarballContentsFromBuild = [];
        };

        modules = [ self.nixosModules.default ];
    };
  };
}