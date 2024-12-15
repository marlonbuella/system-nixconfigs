{
  inputs = {
    base.url = "git+file:///home/alonbuella/.src/projects/nix-mbuella-pc-wsl?dir=nixos.new/00-inputs/00-base";
    # base.url = "../00-inputs/00-base";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "base/nixpkgs";
    };
  };

  outputs = { self, nixos-generators, ... }: {
    nixosModules.default.imports = [ nixos-generators.nixosModules.all-formats ];
  };
}