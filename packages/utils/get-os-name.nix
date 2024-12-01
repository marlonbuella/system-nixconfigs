{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "get-os-name";
  src = null;
  __noChroot = true;
  buildCommand = with pkgs; ''
    osQuery=$(${lsb-release}/bin/lsb_release -i)
    echo $osQuery | ${gnused}/bin/sed 's/Distributor ID: //g' > $out
  '';
}