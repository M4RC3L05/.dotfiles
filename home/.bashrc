# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Colors
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
RESET="\033[0m"

# Exports
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# Alias
alias cat="bat --plain"
alias ls="eza --color=auto --header --git --icons"
alias prime-run="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only"

# Mise
eval "$(mise activate bash)"

# Prompt
PS1="$RED[$YELLOW\u$GREEN@$BLUE\h$RESET $MAGENTA\w$RED]$RESET\$ "

# bash completion
if [ -f $HOME/.nix-profile/etc/profile.d/bash_completion.sh ]; then
  . $HOME/.nix-profile/etc/profile.d/bash_completion.sh
fi

# Greeting
the-office-quote
