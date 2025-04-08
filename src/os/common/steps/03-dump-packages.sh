#!/usr/bin/env sh

set -e

if ! systemctl --user is-enabled dump-packages.timer > /dev/null 2>&1; then
  log_info "Enable dump package cron"
  (set -x; systemctl --user enable --now dump-packages.timer)
fi
