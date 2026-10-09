if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

[[ $- != *i* ]] && return

. ~/.config/shell/alias