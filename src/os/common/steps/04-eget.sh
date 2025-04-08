#!/usr/bin/env sh

set -e

log_info "Setup eget"
if [ -z "$EGET_PACKAGES" ]; then
  log_warning "No eget packages to install"
else
  log_info "Setup eget packages"
  echo "$EGET_PACKAGES" | while read -r package; do
    (set -x; eget "$package" --upgrade-only --to "$HOME"/.local/bin/)
  done
fi
