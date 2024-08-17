# start fish shell
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} && ${SHLVL} == 1 ]]; then
  shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=''
  exec env SHELL="$(which fish)" $(which fish) $LOGIN_OPTION
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# load alias
. $HOME/.alias

PS1='[\u@\h \W]\$ '
