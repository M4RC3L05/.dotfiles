#!/usr/bin/env sh

set -e

log_info "Setup mpv"
(set -x; sudo pacman -S --needed --noconfirm mpv)
