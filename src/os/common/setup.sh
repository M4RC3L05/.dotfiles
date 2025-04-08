#!/usr/bin/env sh

set -e

for step in "$DOTFILES_DIR"/src/os/common/steps/*.sh; do
  log_info "Running step \"$(basename "$step")\""
  # shellcheck source=/dev/null
  . "$step"
done
