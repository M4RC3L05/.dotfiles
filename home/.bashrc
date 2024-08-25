# nix
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
  . $HOME/.nix-profile/etc/profile.d/nix.sh
fi

# start fish shell
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} && ${SHLVL} == 1 ]]; then
  shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=''

  fish_path="$(which fish)"

  exec env SHELL="$fish_path" "$fish_path" $LOGIN_OPTION
fi

# set shell env
SHELL="$(which bash)"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# bat ast manpager
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# load alias
. $HOME/.alias

PS1='[\u@\h \W]\$ '

# mise
eval "$(mise activate bash)"
