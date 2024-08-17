# nix
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
  . $HOME/.nix-profile/etc/profile.d/nix.sh;
fi

# brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# load bin paths
export PATH="$HOME/AppImages:~/.local/bin:$PATH"
export PATH="$HOME/AppImages:$PATH"

# start fish shell
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} && ${SHLVL} == 1 ]]; then
  shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=''
  exec env SHELL="$(which fish)" $(which fish) $LOGIN_OPTION
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# load alias
. $HOME/.alias

# homebrew bash completions
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

PS1='[\u@\h \W]\$ '
