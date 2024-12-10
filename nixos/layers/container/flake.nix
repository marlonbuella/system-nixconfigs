{
  inputs = {
    baseflake.url = "../..";
    nixos-shell = {
      url = "github:Mic92/nixos-shell";
      inputs.nixpkgs.follows = "baseflake/nixpkgs";
    };
  };

  outputs = { self, baseflake, ... }@inputs: baseflake.outputs // {
    nixosModules.default.imports = [
      inputs.nixos-shell.nixosModules.nixos-shell
      ./.
    ];

    nixosConfigurations.default = baseflake.nixosConfigurations.default.extendModules {
        modules = [ self.nixosModules.default ];
    };
  };
}