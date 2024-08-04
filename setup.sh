#!/usr/bin/env sh

set -e

BOLD='\033[1m'
GREEN='\033[32m'
CYAN='\033[36m'
RESET='\033[0m'

run_and_print() {
  printf "+ %s\n" "$*"

  "$@"
}

print_title() {
  printf "${GREEN}==>${RESET} ${BOLD}%s${RESET}\n" "$1"
}

print_sub_title() {
  printf "${CYAN}=>${RESET} %s\n" "$1"
}

install_homebrew_step() {
  if command -v /home/linuxbrew/.linuxbrew/bin/brew > /dev/null 2>&1; then
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
  run_and_print brew bundle install --no-lock -v --describe --no-upgrade
}

stow_files_step() {
  run_and_print stow --no-folding files
}

install_fisher_and_plugins_step() {
  if [ -e ~/.config/fish/functions/fisher.fish ]; then
    print_sub_title "Fisher already installed, skipping"
  else
    run_and_print fish --command "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"
  fi
}

add_fish_shell_as_shell_option_step() {
  shell_to_check="/home/linuxbrew/.linuxbrew/bin/fish"

  if grep -q "^$shell_to_check$" /etc/shells; then
    print_sub_title "Fish shell already on /etc/shells, skipping"
  else
    run_and_print sudo bash -c "echo \"/home/linuxbrew/.linuxbrew/bin/fish\" >> /etc/shells"
  fi
}

change_default_shell_step() {
  user_login_shell="$(grep "^$(whoami):" /etc/passwd | cut -d: -f7)"

  if [ "$user_login_shell" = '/home/linuxbrew/.linuxbrew/bin/fish' ]; then
    print_sub_title "Fish shell is already your login shell, skipping"
  else
    run_and_print chsh -s /home/linuxbrew/.linuxbrew/bin/fish
  fi
}


print_title "Install homebrew"
install_homebrew_step
echo

print_title "Load brew ENV"
load_brew_env_step
echo

print_title "Install brew packages"
install_brew_packages_step
echo

print_title "Stow files"
stow_files_step
echo

print_title "Install fisher & Plugins"
install_fisher_and_plugins_step
echo

print_title "Add fish shell as shell option"
add_fish_shell_as_shell_option_step
echo

print_title "Change default shell"
change_default_shell_step
echo

echo "All done, open a new shell to get started !!!"
