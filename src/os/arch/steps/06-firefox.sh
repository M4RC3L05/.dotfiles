#!/usr/bin/env sh

set -e

log_info "Setup firefox"
(set -x; sudo pacman -S --needed --noconfirm firefox)

if [ ! -f "/etc/firefox/policies/policies.json" ]; then
  log_info "Setup policy"
  (set -x; sudo mkdir -p /etc/firefox/policies)
  (set -x; sudo touch /etc/firefox/policies/policies.json)
  (set -x; sudo cat "$DOTFILES_DIR/src/os/common/files/firefox/policies.json" | sudo tee /etc/firefox/policies/policies.json > /dev/null)
fi
