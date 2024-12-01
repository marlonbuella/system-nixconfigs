{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "get-vscode-win-version-hash";
  src = "/bin";
  __noChroot = true;
  buildCommand = with pkgs; ''
    shopt -s expand_aliases
    alias wslpath=$src/wslpath

    $(wslpath 'C:\Windows\System32\WindowsPowerShell\v1.0')/powershell.exe -Command '& {code --version}' | ${gnused}/bin/sed -n '2p' > $out
  '';
}