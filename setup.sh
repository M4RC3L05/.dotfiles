#!/usr/bin/env sh

set -e

# Install brew
echo "==> Installing brew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Disable brew analitics
brew analytics off

# Setup fish shell
echo "==> Install fish shell"
brew install fish

echo "==> Add fish shell to shells"
sudo sh -c "echo $(which fish) >> /etc/shells"

echo "==> Setting fish as the default user shell"
chsh -s $(which fish)

# Install packages
echo "==> Installing packages"
brew install \
  stow \
  bat \
  exa \
  asdf \
  git \
  fisher

# Stow
echo "==> Stowing"
stow --no-folding files

echo "==> All done, you can reload/restart"