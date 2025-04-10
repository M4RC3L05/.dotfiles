#!/usr/bin/env sh

set -e

log_info "Setup vscode"
(set -x; sudo pacman -S --needed --noconfirm code trash-cli)

if [ -z "$VSCODE_EXTENSIONS" ]; then
  log_warning "No vscode extensions to install"
else
  log_info "Setup vscode extensions"
  echo "$VSCODE_EXTENSIONS" | while read -r extension; do
    (set -x; code --install-extension "$extension")
  done
fi
