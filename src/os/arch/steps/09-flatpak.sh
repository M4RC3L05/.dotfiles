#!/usr/bin/env sh

set -e

log_info "Setup flatpak"
(set -x; sudo pacman -S --needed --noconfirm flatpak)
(set -x; sudo pacman -S --needed --noconfirm gnome-software)

log_info "Setup flatpak remotes"
(set -x; flatpak remote-add --user --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo)
(set -x; flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo)

if [ -z "$FLATPAK_RUNTIMES" ]; then
  log_warning "No flatpak runtimes to install"
else
  log_info "Install flatpak runtimes"
  echo "$FLATPAK_RUNTIMES" | while read -r origin runtime; do
    (set -x; flatpak install --user -y --noninteractive "$origin" "$runtime")
  done
fi

log_info "Install flatpack apps and runtimes"
if [ -z "$FLATPAK_APPS" ]; then
  log_warning "No flatpak apps to install"
else
  log_info "Install flatpak apps"
  echo "$FLATPAK_APPS" | while read -r origin app; do
    if [ "$origin" = "youtube_music-origin" ]; then
      continue
    fi

    (set -x; flatpak install --user -y --noninteractive "$origin" "$app")
  done
fi
