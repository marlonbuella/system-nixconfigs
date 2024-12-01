#!/usr/bin/env bash
# set -xe
set -xe
shopt -s expand_aliases

NIX_EXPERIMENTAL_FLAGS="--extra-experimental-features 'nix-command flakes'"
alias sudo-nix="sudo $(which nix) ${NIX_EXPERIMENTAL_FLAGS}"
alias nix="nix ${NIX_EXPERIMENTAL_FLAGS}"
alias nixos-install="sudo-nix shell nixpkgs#nix nixpkgs#nixos-install-tools --command nixos-install"

echo "Building via nix-build..."
export NIXOS_BUILD=$(
  sudo $(which nix-build) \
    -I nixpkgs=channel:nixos-24.11-small \
    -I nixos-config=./configuration.nix \
    '<nixpkgs/nixos>' \
    -A system \
    --no-out-link \
    --quiet \
    --option sandbox relaxed
)
echo "done!"
# nix build \
#   -A system \
#   --no-out-link \
#   nixpkgs#nixos \
#   .#mbuella-pc-wsl

# # create tar file and mount it
# tar \
#   --no-same-owner \
#   --no-same-permissions \
#   --owner=root \
#   --group=root \
#   --numeric-owner \
#   --absolute-names \
#   --atime-preserve=system \
#   -cf /tmp/nixos.tar \
#   -T /dev/null
# mkdir -p /mnt/nixos
# sudo-nix shell nixpkgs#archivemount --command archivemount /tmp/nixos.tar /mnt/nixos

# recreate build dir
sudo rm -rf /tmp/nixos /c/Users/alonbuella/.local/wsl/disks/nixos.tar
mkdir -p /tmp/nixos

# build NixOS config to the build dir
nixos-install \
  --root /tmp/nixos \
  `#--flake .#mbuella-pc-wsl` \
  --system $NIXOS_BUILD \
  --no-root-password \
  --no-bootloader
  # --impure \
  # --option sandbox relaxed

# # additional wsl setup
# mkdir -p /tmp/nixos/{s,}bin
mkdir -p /tmp/nixos/{,s}bin
ln -s /nix/var/nix/profiles/system/init /tmp/nixos/sbin/
# ln -s /nix/var/nix/profiles/system/sw/bin /tmp/nixos/bin
ln -s /nix/var/nix/profiles/system/sw/bin/mount /tmp/nixos/bin/
mkdir -p /tmp/nixos/usr/local
ln -s /nix/var/nix/profiles/system/sw/bin /tmp/nixos/usr/local/
cat <<EOF | sudo tee /tmp/nixos/etc/wsl.conf
[boot]
command=/sbin/init
systemd=true

# [automount]
# enabled=false
# mountFsTab=true
# # root=/

# [interop]
# appendWindowsPath=false

[user]
default=alonbuella
EOF

sudo tar \
  --no-same-owner \
  --no-same-permissions \
  --owner=root \
  --group=root \
  --numeric-owner \
  --absolute-names \
  --atime-preserve=system \
  -z \
  -cf \
  /c/Users/alonbuella/.local/wsl/disks/nixos.tar.gz \
  -C /tmp/nixos . &

exit 0;

# Install VS Code server CLI compatible with NixOS
cd ~
export VSCODE_WIN_VERSION_HASH=$(powershell.exe -Command '& {code --version}' | sed -n '2p')
curl -Lo /tmp/code-server.tar.gz https://update.code.visualstudio.com/commit:$VSCODE_WIN_VERSION_HASH/server-linux-x64/stable
tar xzf /tmp/code-server.tar.gz
mkdir -p ~/.vscode-server/bin
mv vscode-server-linux-x64 ~/.vscode-server/bin/$VSCODE_WIN_VERSION_HASH
rm -f ~/.vscode-server/bin/$VSCODE_WIN_VERSION_HASH/node
ln -s $(which node) ~/.vscode-server/bin/$VSCODE_WIN_VERSION_HASH/node