#!/usr/bin/env sh

set -e

log_info "Setup firewall"
(set -x; sudo pacman -S --needed --noconfirm gufw)

if ! systemctl is-enabled ufw > /dev/null 2>&1; then
  log_info "Enable firewall service"
  (set -x; systemctl enable --now ufw)
fi

if sudo ufw status | grep -q "inactive"; then
  log_info "Enable ufw"
  (set -x; sudo ufw enable)
fi

log_info "Add localsend to firewall exclusion"
sudo ufw allow 53317/udp
sudo ufw allow 53317/tcp

log_info "Add syncthing to firewall exclusion"
sudo ufw allow 22000/udp
sudo ufw allow 21027/udp
