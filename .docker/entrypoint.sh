#!/usr/bin/env sh

set -ex

export USER="$(whoami)"

sudo dbus-daemon --system
flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo

git config --global user.email "foo@bar.com"
git config --global user.name "foo"

cd /home/main/.dotfiles && git add . && git commit -sm "wip" -n && cd /home/main

exec "$@"
