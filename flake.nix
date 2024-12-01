{
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11-small";
    # nixos-generators = {
    #   url = "github:nix-community/nixos-generators";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.mbuella-pc-wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        isBuild = false;
      };
      modules = [
        ./configuration.nix
      ];
    };
    nixosConfigurations.mbuella-pc-wsl-build = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        # nixos-generators = nixos-generators;
        isBuild = true;
      };
      modules = [
        # ./nixos-generator/formats.nix
        ./configuration.nix
      ];
    };
    
    #  = nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";
    #   specialArgs = {
    #     nixos-generators = nixos-generators;
    #   };
    #   modules = self.nixosConfigurations.mbuella-pc-wsl.modules ++ [
    #     ./nixos-generator/formats.nix
    #   ];
    # };
    # nixosConfigurations."ALONPC" = self.nixosConfigurations.mbuella-pc-wsl;

    # # for systems which does not have nixos-install-tools
    # packages.x86_64-linux.nixos-install-tools = nixpkgs.legacyPackages.x86_64-linux.nixos-install-tools;

    # # for systems which does not have nixos-rebuild
    # packages.x86_64-linux.nixos-rebuild = nixpkgs.legacyPackages.x86_64-linux.nixos-rebuild;
    # packages.x86_64-linux.default = self.packages.x86_64-linux.nixos-rebuild;

  };
}
