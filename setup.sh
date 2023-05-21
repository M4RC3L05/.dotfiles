#!/usr/bin/env sh

set -e

# Install nix
curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
. ~/.nix-profile/etc/profile.d/nix.sh

# Install packages
echo "==> Installing packages"
nix-env -iA \
  nixpkgs.stow \
  nixpkgs.bat \
  nixpkgs.exa \
  nixpkgs.fish \
  nixpkgs.git

# Setup fish shell
echo "==> Add fish shell to shells"
sudo sh -c "echo $(which fish) >> /etc/shells"

echo "==> Setting fish as the default user shell"
chsh -s $(which fish)

# Stow
echo "==> Stowing"
stow --no-folding files

echo "==> Install fisher"
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"

# Setup asdf
echo "==> Install asdf"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3

echo "==> Setup asdf fish shell completions"
mkdir -p ~/.config/fish/completions && ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions

echo "==> All done, you can reload/restart"