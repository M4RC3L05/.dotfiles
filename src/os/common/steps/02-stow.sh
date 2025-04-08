#!/usr/bin/env sh

set -e

log_info "Stow files"
(set -x; cd "$DOTFILES_DIR" && stow --adopt --no-folding -v home)
(set -x; cd "$DOTFILES_DIR" && git restore home)
