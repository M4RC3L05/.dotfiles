#!/usr/bin/env sh

set -e

log_info "Refresh repos"
(set -x; sudo pacman -Syyuu)
