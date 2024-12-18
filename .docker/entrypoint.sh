#!/usr/bin/env sh

set -x

flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

git config --global user.email "foo@bar.com"
git config --global user.name "foo"

cd /home/main/.dotfiles && git add . && git commit -sm "wip" -n && cd /home/main
