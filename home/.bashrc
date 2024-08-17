# start fish shell
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} && ${SHLVL} == 1 ]]; then
  shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=''
  exec env SHELL="/home/linuxbrew/.linuxbrew/bin/fish" /home/linuxbrew/.linuxbrew/bin/fish $LOGIN_OPTION
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# bat ast manpager
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# load alias
. $HOME/.alias

PS1='[\u@\h \W]\$ '
