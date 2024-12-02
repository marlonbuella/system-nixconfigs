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
    alias cmd=$(wslpath 'C:\Windows\System32\cmd.exe')
    alias ps=$(wslpath 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe')

    export defaultMountDir=${defaultMountDir}
    # need to remove trailing slash if default dir has one
    [[ $defaultMountDir != '/' ]] && defaultMountDir=$(realpath -s $defaultMountDir)

    # Determine current mount dir via cmd.exe's %windir% converted to WSL path.
    currentMountDir=$(wslpath $(cmd /s /c 'echo %windir%') | head -n 1 | sed 's/\r//g' | sed 's/c\/WINDOWS//')
    # need to remove trailing slash if current dir has one
    [[ $currentMountDir != '/' ]] && currentMountDir=$(realpath -s $currentMountDir)

    IFS=";" WINPATHS=$(ps -Command '& {echo $env:path}')

    export PATHS=

    for WINPATH in $WINPATHS; do
      WINPATH=$(wslpath "$WINPATH" | sed "0,/\\$currentMountDir\//s//\\$defaultMountDir\//" | sed 's/\/$//')
      PATHS="$PATHS:$WINPATH"
    done

    # cleanup of PATHS from extra characters
    PATHS=$(printf $PATHS | sed 's/^\://')

    printf $PATHS > $out
  '';
}
