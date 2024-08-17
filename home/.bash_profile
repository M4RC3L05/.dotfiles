# nix
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
  . $HOME/.nix-profile/etc/profile.d/nix.sh;
fi

# brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# load bin paths
export PATH="$HOME/AppImages:$HOME/.local/bin:$PATH"

[[ -f ~/.bashrc ]] && . ~/.bashrc
