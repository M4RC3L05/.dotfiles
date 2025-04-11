#!/usr/bin/env sh

set -e

log_info "Setup Gnome"
(set -x; gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer', 'variable-refresh-rate', 'xwayland-native-scaling']")
(set -x; gsettings set org.gnome.desktop.interface color-scheme "prefer-dark")
(set -x; gsettings set org.gnome.desktop.interface accent-color "orange")
(set -x; gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled "true")
(set -x; gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature "2500")
(set -x; gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic "false")
(set -x; gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from "18.0")
(set -x; gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to "9.0")
(set -x; gsettings set org.gnome.Epiphany.web:/ hardware-acceleration-policy 'always' || true)

if ! systemctl is-enabled bluetooth > /dev/null 2>&1; then
  log_info "Enable bluetooth service"
  (set -x; systemctl enable --now bluetooth)
fi

log_info "Setup legacy gtk theme"
log_warning "Set the theme using gnome-tweaks"
(set -x; sudo pacman -S --needed --noconfirm adw-gtk-theme)

# Install https://github.com/mukul29/legacy-theme-auto-switcher-gnome-extension manually
log_info "Setup gnome extensions"
log_warning "\`legacy-theme-auto-switcher-gnome-extension\` must be setup manually"
(set -x; sudo pacman -S --needed --noconfirm gnome-shell-extension-caffeine gnome-shell-extension-appindicator)
