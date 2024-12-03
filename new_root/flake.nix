{
  inputs = {
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    flake-utils.follows = "nix-vscode-extensions/flake-utils";
    nixpkgs.follows = "nix-vscode-extensions/nixpkgs";
  };

  outputs =
    inputs: inputs.flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        extensions = inputs.nix-vscode-extensions.extensions.${system};
        inherit (pkgs) vscode-with-extensions 
        # vscodium
        ;

        packages.default = vscode-with-extensions.override {
        #   vscode = vscodium;

          vscodeExtensions = [
            extensions.vscode-marketplace.bbenoist.nix
            extensions.vscode-marketplace.mhutchie.git-graph
          ];
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ packages.default ];
          shellHook = ''
            export PATH="/c/Users/alonbuella/AppData/Local/Programs/Microsoft\ VS\ Code/bin:$PATH"
            echo "This is my NixOS development environment."
          '';
        };
      in
      {
        inherit packages devShells;
      }
    );
}