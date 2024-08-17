if status is-interactive
  set fish_greeting

  # hydro
  set -g hydro_color_pwd green
  set -g hydro_color_prompt magenta
  set -g hydro_color_duration yellow

  # aliases
  source $HOME/.alias

  # brew
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
