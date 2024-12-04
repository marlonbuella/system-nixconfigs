{
  inputs = {
    baseflake.url = "../..";
    nixpkgs.follows = "baseflake/nixpkgs";
  };

  outputs = { self, nixpkgs, baseflake, ... }: baseflake.outputs // {
    nixosConfigurations = {
        default = baseflake.nixosConfigurations.default.extendModules {
            modules = [ ./. ];
        };
        debug = self.nixosConfigurations.default.extendModules {
            modules = [ ../../configs/debug ];
        };
    };
  };
}
