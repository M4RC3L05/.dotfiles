[[ $- != *i* ]] && return

alias cat="bat --plain"
alias eza="eza --icons auto --color auto --git"
alias ls="eza"
alias proxyK8sServer="ssh -NL 6443:127.0.0.1:6443 mainserver"
alias kubectl="kubecolor"

HISTCONTROL="ignoreboth"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv | grep -Ev '\bPATH=')"
HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/home/linuxbrew/.linuxbrew}"
export PATH="${PATH}:${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin"

if ! test -L /home/linuxbrew/.linuxbrew/etc/bash_completion.d/brew; then
  /home/linuxbrew/.linuxbrew/bin/brew completions link > /dev/null
fi

if test -d /home/linuxbrew/.linuxbrew/etc/bash_completion.d; then
  for rc in /home/linuxbrew/.linuxbrew/etc/bash_completion.d/*; do
    if test -r "$rc"; then
      . "$rc"
    fi
  done
  unset rc
fi

if [ -f "/home/linuxbrew/.linuxbrew/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR="/home/linuxbrew/.linuxbrew/opt/bash-git-prompt/share"
  source "/home/linuxbrew/.linuxbrew/opt/bash-git-prompt/share/gitprompt.sh"
fi

eval "$(mise activate bash)"
eval "$(batman --export-env)"

exit_status() {
  local exit_statuses=("$@")

  for exit_status in "${exit_statuses[@]}"; do
    if [[ "$exit_status" != "0" ]]; then
      local exit_statuses_joined="${exit_statuses[*]}"
      echo -en " \e[31m[${exit_statuses_joined// / | }]\e[0m"

      break
    fi
  done
}

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS="true"
GIT_PS1_SHOWUPSTREAM="verbose"
PROMPT_COMMAND='__git_ps1 "\[\e]0;\w\a\]\[\033[92m\]\u\[\033[0m\]@\h \[\033[32m\]\w\[\033[0m\]" "$(exit_status "${PIPESTATUS[@]}")\\\$ "'

quotes all
echo
