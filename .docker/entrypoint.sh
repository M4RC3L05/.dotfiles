#!/usr/bin/env sh

set -x

git config --global user.email "foo@bar.com"
git config --global user.name "foo"

cd /home/main/.dotfiles || exit
git add .
git commit -sm "wip" -n
cd /home/main || exit
sed -i '$d' ~/.bashrc
