{
  inputs = {
    baseflake.url = "../..";
    nixos-generator = {
      url = "../../configs/nixos-generator";
      inputs.baseflake.follows = "baseflake"; 
    };
  };

  outputs = { self, baseflake, nixos-generator, ... }: {
    nixosConfigurations = 
    let
      nixosGeneratorVm = nixos-generator.nixosConfigurations.default;
    in
    {
        default = nixosGeneratorVm.extendModules {
            modules = [ ./. ];
        };
        debug = self.nixosConfigurations.default.extendModules {
            modules = [ ../../configs/debug ];
        };
    };
  };
}
