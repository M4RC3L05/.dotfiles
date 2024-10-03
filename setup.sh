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
  if command -v nix > /dev/null 2>&1; then
    print_sub_title "Nix already installed, skipping"
  else
    run_and_print "curl -L https://nixos.org/nix/install | sh -s -- --no-daemon --yes --no-modify-profile"
    run_and_print ". ~/.nix-profile/etc/profile.d/nix.sh"
    run_and_print nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
    run_and_print nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl
    run_and_print nix-channel --update

    run_and_print mkdir -p ~/.config/nixpkgs

    if [ -f ~/.config/nixpkgs/config.nix ]; then
      run_and_print rm ~/.config/nixpkgs/config.nix
    fi

    run_and_print cp ./home/.config/nixpkgs/config.nix ~/.config/nixpkgs/config.nix

    run_and_print nix-env -iAr nixpkgs.mainPackages

    run_and_print mkdir -p ~/.config/systemd
    run_and_print "printf '[Manager]\nManagerEnvironment=\"XDG_DATA_DIRS=%s/.nix-profile/share:/usr/local/share:/usr/share\"' \"$HOME\" > ~/.config/systemd/user.conf"
  fi
}

install_mise_step() {
  if command -v mise > /dev/null 2>&1; then
    print_sub_title "Mise already installed, skipping"
  else
    run_and_print "curl https://mise.run | sh"
    run_and_print mkdir -p ~/.config/mise
    run_and_print cp ./home/.config/mise/config.toml ~/.config/mise/config.toml
    run_and_print ~/.local/bin/mise install

    print_sub_title "Install mise completions"
    run_and_print mkdir -p ~/.local/share/bash-completion/completions
    run_and_print "~/.local/bin/mise completion bash > ~/.local/share/bash-completion/completions/mise.bash"
  fi
}

stow_files_step() {
  run_and_print stow --adopt --no-folding -v home
  run_and_print git restore home
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

install_vscode_extensions_step() {
  if command -v code > /dev/null 2>&1; then
    extension_flags=""

    while IFS= read -r extension; do
      if [ -n "$extension" ]; then
        extension_flags="$extension_flags --install-extension $extension"
      fi
    done < "$PACKAGES_DIR/vscode-extensions"

    if [ -n "$extension_flags" ]; then
      run_and_print code $extension_flags
    else
      print_sub_title "No extensions to install, skipping"
    fi
  else
    print_sub_title "VSCode is not installed, skipping"
  fi
}

###
# MAIN
###

print_title "Install nix"
install_nix_step
echo

print_title "Install mise"
install_mise_step
echo

print_title "Stow files"
stow_files_step
echo

print_title "Install eget packages"
install_eget_packages_step
echo

print_title "Install flatpak apps and runtimes"
install_flatpak_apps_and_runtimes_step
echo


print_title "Install vscode extensions"
install_vscode_extensions_step
echo

printf "%b✓%b All done, open a new shell to get started !!!\n" "$GREEN" "$RESET"
