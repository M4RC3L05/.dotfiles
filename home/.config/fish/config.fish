if status is-interactive
  # hydro
  set -g hydro_color_pwd green
  set -g hydro_color_prompt magenta
  set -g hydro_color_duration yellow

  set -Ux MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

  # aliases
  source $HOME/.alias

  # brew
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
