#!/usr/bin/env sh

set -e

# Setup fish shell
echo "==> Install fish shell"
yay -S --noconfirm fish

echo "==> Add fish shell to shells"
sudo sh -c "echo $(which fish) >> /etc/shells"

echo "==> Setting fish as the default user shell"
chsh -s $(which fish)

# Install packages
echo "==> Installing packages"
yay -S --noconfirm \
  base-devel \
  stow \
  bat \
  exa \
  git \
  vim

# Stow
echo "==> Stowing"
stow --no-folding files

# Install fisher
echo "==> Install fisher"
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"

## Install asdf
echo "==> Install asdf"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3

# Init fish
echo "==> Sourcing fish"
fish -c "source ~/.config/fish/config.fish"

echo "==> All done, you can reload/restart"