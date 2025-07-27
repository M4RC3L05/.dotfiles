###
# UTILS & VARS
###

# shellcheck disable=SC2034
# shellcheck source=/dev/null
ID="$(
  . /etc/os-release
  echo "$ID"
)"

GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
PURPLE="\033[0;35m"
RED="\033[0;31m"
RESET="\033[0m"

DOTFILES_DIR="$HOME/.dotfiles"
PACKAGES_DIR="$DOTFILES_DIR/src/packages"

PS4="$PURPLE\$ $RESET"

log() {
  case "$1" in
    INFO)
      printf "%b[%s]%b %s\n" "$BLUE" "INFO" "$RESET" "$2"
      ;;
    WARNING)
      printf "%b[%s]%b %s\n" "$YELLOW" "WARNING" "$RESET" "$2"
      ;;
    SUCCESS)
      printf "%b[%s]%b %s\n" "$GREEN" "SUCCESS" "$RESET" "$2"
      ;;
    ERROR)
      printf "%b[%s]%b %s\n" "$RED" "ERROR" "$RESET" "$2"
      ;;
  esac
}

log_info() {
  log "INFO" "$1"
}

log_success() {
  log "SUCCESS" "$1"
}

log_warning() {
  log "WARNING" "$1"
}

log_error() {
  log "ERROR" "$1"
}

resolve_packages_from_context() {
  case "$1" in
    endeavouros)
      cat "$PACKAGES_DIR"/os/arch-packages
      ;;
    flatpak-apps)
      cat "$PACKAGES_DIR"/flatpak-apps
      ;;
    flatpak-runtimes)
      cat "$PACKAGES_DIR"/flatpak-runtimes
      ;;
    eget)
      cat "$PACKAGES_DIR"/eget-packages
      ;;
    *)
      echo ""
      ;;
  esac
}

install() {
  case "$1" in
    endeavouros)
      (
        set -x
        sudo pacman -S --needed --noconfirm "$2"
      )
      ;;
    flatpak-apps | flatpak-runtimes)
      (
        set -x
        flatpak install --user -y --noninteractive "$2" "$3"
      )
      ;;
    eget)
      (
        set -x
        /home/linuxbrew/.linuxbrew/bin/eget "$2" --upgrade-only --to "$HOME"/.local/bin/
      )
      ;;
    *)
      log_warning "Context \"$1\" not recognized, will not install"
      ;;
  esac
}

install_packages() {
  packages="$(resolve_packages_from_context "$1")"

  if [ -z "$packages" ]; then
    log_warning "No packages to install for \"$1\""
  else
    echo "$packages" | while read -r package_or_repo package; do
      if [ "$package_or_repo" = "youtube_music-origin" ]; then
        log_warning "Install $package_or_repo $package from github manually"
        continue
      fi

      if echo "$package_or_repo" | grep -qE '^\s*$'; then
        continue
      fi

      if echo "$package_or_repo" | grep -qE '^\s*#'; then
        continue
      fi

      install "$1" "$package_or_repo" "$package"
    done
  fi
}

upgrade_package_manager_repos() {
  case "$ID" in
    endeavouros)
      (
        set -x
        sudo pacman -Syyuu
      )
      ;;
  esac
}
