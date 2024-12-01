{ defaultMountDir, pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "generate-windows-paths";
  src = "/bin";
  __noChroot = true;
  buildCommand = 
  # let
  #   currentMountDir=(builtins.fromTOML (builtins.readFile "/etc/wsl.conf")).automount.root;
  # in
  ''
    shopt -s expand_aliases
    alias wslpath=$src/wslpath

    # need to remove trailing slash if default dir has one
    export defaultMountDir=${defaultMountDir}
    [[ $defaultMountDir != '/' ]] && defaultMountDir=$(echo ${defaultMountDir} | sed "s,/$,,")

    export currentMountDir=$(${pkgs.tomlq}/bin/tq -f /etc/wsl.conf 'automount.root')
    # need a way to compare it with current set prefix and use it instead
    # need to remove trailing slash if current dir has one
    [[ $currentMountDir != '/' ]] && currentMountDir=$(echo $currentMountDir | sed "s,/$,,")

    IFS=";" WINPATHS=`$(wslpath 'C:\Windows\System32\WindowsPowerShell\v1.0')/powershell.exe -Command '& {echo $env:path}'`

    export PATHS=

    for WINPATH in $WINPATHS; do
      WINPATH=$(wslpath "$WINPATH" | xargs | sed "0,/\\$currentMountDir\//s//\\$defaultMountDir\//")
      PATHS="$PATHS:$WINPATH"
    done

#    echo $PATHS
#    exit 1

    echo $PATHS > $out
  '';
}
