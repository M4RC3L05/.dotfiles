#!/usr/bin/env sh

set -e

log_info "Setup bitwarden"
(set -x; sudo pacman -S --needed --noconfirm bitwarden)
