#!/usr/bin/env sh

set -x

export USER="$(whoami)"

sudo dbus-daemon --system
flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo

git config --global user.email "foo@bar.com"
git config --global user.name "foo"

cd ~/.dotfiles && git add . && git commit -sm "wip" -n && cd

exec "$@"
