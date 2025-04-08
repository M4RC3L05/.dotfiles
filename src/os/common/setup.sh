#!/usr/bin/env sh

log_info "Setup nix"

if ! command -v nix > /dev/null 2>&1; then
  (set -x; curl -L https://nixos.org/nix/install | sh -s -- --no-daemon --yes --no-modify-profile --no-channel-add)

  # shellcheck source=/dev/null
  . "$HOME"/.nix-profile/etc/profile.d/nix.sh

  nix_binary_path="$(readlink -f "$(which nix)")"
  nix_profile_index="$(nix --extra-experimental-features 'nix-command flakes' profile list | grep "$(echo "$nix_binary_path" | sed 's|^/nix/store/\([^/]*\)/.*$|\1|g')" | awk '{print $3}')"
  (set -x; nix --extra-experimental-features 'nix-command flakes' profile remove "$nix_profile_index")
  (set -x; "$nix_binary_path" --extra-experimental-features 'nix-command flakes' profile install nixpkgs#nix)
fi

if [ -z "$NIX_PACKAGES" ]; then
  log_warning "No nix packages to install"
else
  log_info "Setup nix packages"
  echo "$NIX_PACKAGES" | while read -r package; do
    case "$package" in
      *podman*|*syncthing*)
        log_warning "Service \"$package\" need to be manually enabled after restarting the computer"
        ;;
    esac

    (set -x; nix --extra-experimental-features 'nix-command flakes' profile install nixpkgs#"$package")
  done
fi

log_info "Stow files"
(set -x; cd "$DOTFILES_DIR" && stow --adopt --no-folding -v home)
(set -x; cd "$DOTFILES_DIR" && git restore home)

if ! systemctl --user is-enabled dump-packages.timer > /dev/null 2>&1; then
  log_info "Enable dump package cron"
  (set -x; systemctl --user enable --now dump-packages.timer)
fi

log_info "Setup ubi"
(set -x; curl --silent --location https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh | TARGET="$HOME/.local/bin" sh)

if [ -z "$UBI_PACKAGES" ]; then
  log_warning "No ubi packages to install"
else
  log_info "Setup ubi packages"
  echo "$UBI_PACKAGES" | while read -r package; do
    # shellcheck disable=SC2086
    (set -x; "$HOME"/.local/bin/ubi $package --in "$HOME"/.local/bin -v)
  done
fi
