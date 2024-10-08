#!/usr/bin/env sh

if [ "$(id -u)" -eq 0 ]; then
  echo "This script cannot be run as root. It will call sudo as needed"
  exit 1
fi

set -e

###
# UTILS & VARS
###

BOLD="\033[1m"
CYAN="\033[36m"
GREEN="\033[32m"
RESET="\033[0m"

DIR_NAME="$(realpath "$(dirname "$0")")"
PACKAGES_DIR="$DIR_NAME/packages"

run_and_print() {
  printf "+ %s\n" "$*"

  if [ "$#" -eq 1 ]; then
    eval "$1"
  else
    "$@"
  fi
}

print_title() {
  printf "%b==>%b %b%s%b\n" "$GREEN" "$RESET" "$BOLD" "$1" "$RESET"
}

print_sub_title() {
  printf "%b=>%b %s\n" "$CYAN" "$RESET" "$1"
}

###
# STEPS
###

install_nix_step() {
  if ! command -v nix > /dev/null 2>&1; then
    run_and_print "curl -L https://nixos.org/nix/install | sh -s -- --no-daemon --yes --no-modify-profile"
    run_and_print ". ~/.nix-profile/etc/profile.d/nix.sh"
    run_and_print nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
    run_and_print nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl
    run_and_print nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    run_and_print nix-channel --update
  else
    print_sub_title "nix already installed"
  fi

  if ! command -v home-manager > /dev/null 2>&1; then
    run_and_print nix-shell '<home-manager>' -A install
  else
    print_sub_title "home-manager already installed"
  fi

  run_and_print mkdir -p $HOME/.config/nixpkgs

  if [ -f $HOME/.config/nixpkgs/config.nix ]; then 
    run_and_print rm $HOME/.config/nixpkgs/config.nix
  fi

  run_and_print ln -s $HOME/.dotfiles/nix/config.nix $HOME/.config/nixpkgs/config.nix

  run_and_print mkdir -p $HOME/.config/home-manager

  if [ -f $HOME/.config/home-manager/home.nix ]; then 
    run_and_print rm $HOME/.config/home-manager/home.nix
  fi
  
  run_and_print ln -s $HOME/.dotfiles/nix/home.nix $HOME/.config/home-manager/home.nix

  run_and_print nix-env -iA nixpkgs-unstable.nix nixpkgs-unstable.cacert
  run_and_print home-manager switch -b backup
}

install_eget_packages_step() {
  if [ -n "$(cat "$PACKAGES_DIR/eget-executables")" ]; then

    while IFS= read -r executable; do
      if [ -n "$executable" ]; then
        run_and_print eget $executable --upgrade-only
        echo
      fi
    done < "$PACKAGES_DIR/eget-executables"

  else
    print_sub_title "No eget packages to install, skipping"
  fi
}

install_flatpak_apps_and_runtimes_step() {
  if command -v flatpak > /dev/null 2>&1; then
    if [ -n "$(cat "$PACKAGES_DIR/flatpak-apps")" ]; then
      run_and_print flatpak install -y --noninteractive $(cat "$PACKAGES_DIR/flatpak-apps")
      echo
    else
      print_sub_title "No flatpak apps to install, skipping"
    fi

    if [ -n "$(cat "$PACKAGES_DIR/flatpak-runtimes")" ]; then
      run_and_print flatpak install -y --noninteractive $(cat "$PACKAGES_DIR/flatpak-runtimes")
    else
      print_sub_title "No flatpak runtimes to install, skipping"
    fi
  else
    print_sub_title "Flatpak is not installed, skipping"
  fi
}

###
# MAIN
###

print_title "Install nix"
install_nix_step
echo

print_title "Install eget packages"
install_eget_packages_step
echo

print_title "Install flatpak apps and runtimes"
install_flatpak_apps_and_runtimes_step
echo

printf "%b✓%b All done, restart and open a new shell to get started !!!\n" "$GREEN" "$RESET"
