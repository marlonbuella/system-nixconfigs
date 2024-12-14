{
  inputs = {
    baseflake = {
      url = "../../layers/container";
      inputs.baseflake.url = "../..";
    };
    nixosGenerator = {
      url = "../../layers/nixos-generator";
      inputs.baseflake.url = "../..";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "baseflake/nixpkgs";
    };
  };

  outputs = { self, baseflake, nixosGenerator, vscode-server, ... }: baseflake.outputs // {
    nixosModules = {
      default.imports = [
        ../../configs/dev
        ./.
      ];
      wsl.imports = self.nixosModules.default.imports ++ [ ./wsl.nix ];
    };

    nixosConfigurations = {
        default = baseflake.nixosConfigurations.default.extendModules {
          modules = [ self.nixosModules.default ];
        };
        wsl = nixosGenerator.nixosConfigurations.default.extendModules {
          specialArgs = {
              additionalTarballContents = with self.nixosConfigurations.wsl; [
                {
                  source = config.system.build.toplevel + "/etc/wsl.conf";
                  target = "/etc/wsl.conf";
                }
              ];
          };

          modules = [
            vscode-server.nixosModules.default
            self.nixosModules.wsl
          ];
        };
    };
  };
}
