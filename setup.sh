#!/usr/bin/env sh

if [ "$(id -u)" -eq 0 ]; then
  echo "This script cannot be run as root. It will call sudo as needed"
  exit 1
fi

set -e

###
# UTILS & VARS
###

CURRENT_SHELL_NAME="$(ps -p $$ -o args= | awk '{print $1}')"
FULL_PATH_CURRENT_SHELL_NAME="$(which $CURRENT_SHELL_NAME)"

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
    run_and_print nix-env --install --file '<nixpkgs>' --attr nix -I nixpkgs=channel:nixpkgs-unstable
    run_and_print nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
    run_and_print nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl
    run_and_print nix-channel --update

    run_and_print mkdir -p ~/.config/nixpkgs

    if [ -f ~/.config/nixpkgs/config.nix ]; then
      run_and_print rm ~/.config/nixpkgs/config.nix
    fi

    run_and_print cp ./home/.config/nixpkgs/config.nix ~/.config/nixpkgs/config.nix

    run_and_print nix-env -iA nixgl.auto.nixGLDefault nixgl.nixGLIntel nixgl.auto.nixVulkanNvidia nixgl.nixVulkanIntel
    run_and_print nix-env -iA nixpkgs.mainPackages
    run_and_print "printf '[Manager]\nManagerEnvironment=\"XDG_DATA_DIRS=%s/.nix-profile/share:/usr/local/share:/usr/share\"' \"$HOME\" > ~/.config/systemd/user.conf"
  fi
}

stow_files_step() {
  run_and_print stow --adopt --no-folding -v home
  run_and_print git restore home
}

install_fisher_and_plugins_step() {
  if [ -e ~/.config/fish/functions/fisher.fish ]; then
    print_sub_title "Fisher already installed, skipping"
  else
    run_and_print fish --command "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"
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

print_title "Stow files"
stow_files_step
echo

print_title "Install fisher & plugins"
install_fisher_and_plugins_step
echo

print_title "Install vscode extensions"
install_vscode_extensions_step
echo

print_title "Install flatpak apps and runtimes"
install_flatpak_apps_and_runtimes_step
echo

printf "%b✓%b All done, open a new shell to get started !!!\n" "$GREEN" "$RESET"
