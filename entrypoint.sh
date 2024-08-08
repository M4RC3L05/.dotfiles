#!/usr/bin/env sh

set -x

sudo dbus-daemon --system
flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo

exec "$@"
