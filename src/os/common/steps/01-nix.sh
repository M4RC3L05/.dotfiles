#!/usr/bin/env sh

set -e

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
