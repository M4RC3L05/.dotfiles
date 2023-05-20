#!/usr/bin/env sh

# Install packages
echo "==> Installing packages"
nix-env -iA \
  nixpkgs.stow \
  nixpkgs.bat \
  nixpkgs.exa \
  nixpkgs.fish

# Setup fish shell
echo "==> Add fish shell to shells"
sudo sh -c "echo $(which fish) >> /etc/shells"

echo "==> Setting fish as the default user shell"
chsh -s $(which fish)

# Setup asdf
echo "==> Install asdf"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3
echo "==> Setup asdf fish shell completions"
mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions

# Stow
echo "==> Stowing"
stow files

echo "==> All done, you can reload/restart"