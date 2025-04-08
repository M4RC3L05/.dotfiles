#!/usr/bin/env sh

set -e

log_info "Setup ghostty"
(set -x; sudo pacman -S --needed --noconfirm ghostty)
