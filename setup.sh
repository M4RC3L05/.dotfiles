#!/usr/bin/env sh

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

  "$@"
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

install_homebrew_step() {
  if command -v brew > /dev/null 2>&1; then
    print_sub_title "Brew already installed, skipping"
  else
    run_and_print bash -c "curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | NONINTERACTIVE=1 bash"
  fi
}

load_brew_env_step() {
  run_and_print test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  run_and_print test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
}

install_brew_packages_step() {
  run_and_print brew bundle install --no-lock -v --describe --no-upgrade --file "$PACKAGES_DIR/brew-packages"
}

install_flatpak_apps_and_runtimes_step() {
  if command -v flatpak > /dev/null 2>&1; then
    run_and_print flatpak install -y --noninteractive $(cat "$PACKAGES_DIR/flatpak-apps")
    echo
    run_and_print flatpak install -y --noninteractive $(cat "$PACKAGES_DIR/flatpak-runtimes")
  else
    print_sub_title "Flatpak is not installed, skipping"
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
    while IFS= read -r line; do
      run_and_print code --install-extension "$line"
    done < "$PACKAGES_DIR/vscode-extensions"

  else
    print_sub_title "VSCode is not installed, skipping"
  fi
}

###
# MAIN
###

print_title "Install homebrew"
install_homebrew_step
echo

print_title "Load brew ENV"
load_brew_env_step
echo

print_title "Install brew packages"
install_brew_packages_step
echo

print_title "Install flatpak apps and runtimes"
install_flatpak_apps_and_runtimes_step
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

printf "%b✓%b All done, open a new shell to get started !!!\n" "$GREEN" "$RESET"
