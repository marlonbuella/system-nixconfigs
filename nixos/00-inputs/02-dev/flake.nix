{
  inputs = {
    # dev is just an extension of debug
    base.url = "../01-debug";
  };

  outputs = { self, base, ... }@inputs: base.outputs // {
    nixosModules.default.imports = [ ./. ];

    nixosConfigurations.default = base.nixosConfigurations.default.extendModules {
        modules = [ self.nixosModules.default ];
    };
  };
}