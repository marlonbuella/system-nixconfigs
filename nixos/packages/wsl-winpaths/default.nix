{ defaultWslMountDir, pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation {
  name = "wsl-winpaths";
  src = ./.;
  __noChroot = true;
  buildInputs = [ pkgs.bun pkgs.util-linux ];
  phases = [ "buildPhase" ];
  buildPhase = ''
    # set -x
    
    echo $(
      bun run \
        "$src/build.js" \
        --defaultWslMountDir "${defaultWslMountDir}"
    ) > $out
    
    # exit 1
  '';
}
