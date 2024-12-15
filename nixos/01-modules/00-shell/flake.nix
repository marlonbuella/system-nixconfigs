{
  inputs = {
    base.url = "git+file:///home/alonbuella/.src/projects/nix-mbuella-pc-wsl?dir=nixos.new/00-inputs/00-base";
    nixos-shell = {
      url = "github:Mic92/nixos-shell";
      inputs.nixpkgs.follows = "base/nixpkgs";
    };
  };

  outputs = { self, ... }@inputs: {
    nixosModules.default.imports = [
      inputs.nixos-shell.nixosModules.nixos-shell
      ./.
    ];
  };
}