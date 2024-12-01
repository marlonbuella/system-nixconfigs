{ pkgs, lib, ... }:

let
    get-vscode-win-version-hash = (
        lib.strings.trim
        (builtins.readFile (import ./get-vscode-win-version-hash.nix { inherit pkgs; }))
    );
    vscode-server = fetchTarball {
        url = "https://update.code.visualstudio.com/commit:${get-vscode-win-version-hash}/server-linux-x64/stable";
        sha256 = "1vdhxqzyw5b0wch9s9fjv996f2fs32801z2dj74qfmksmpxldw2f";
    };
in
pkgs.stdenv.mkDerivation {
  name = "vscode-server-wsl";
  src = null;
#   __noChroot = true;
  buildCommand = with pkgs; ''
    mkdir -p $out

    # echo "test" > $out/test
    cp -Ra ${vscode-server}/* $out/

    rm -f $out/node
    ln -s ${nodejs-slim_18}/bin/node $out/node

    echo ${get-vscode-win-version-hash} > $out/.vscode-server-hash
  '';
}