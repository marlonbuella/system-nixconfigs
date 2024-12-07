{
  inputs = {
    baseflake = {
      url = "../../layers/nixos-generator";
      inputs.baseflake.url = "../..";
    };
  };

  outputs = { self, baseflake, ... }: baseflake.outputs // {
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
