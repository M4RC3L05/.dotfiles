function fish_greeting
  quotes all
  echo
end

status is-login; and begin
  # Login shell initialisation
end

status is-interactive; and begin
  # Aliases
  source ~/.config/shell/alias

  # Interactive shell initialisation
  set -g __fish_git_prompt_char_upstream_ahead ↑
  set -g __fish_git_prompt_char_upstream_behind ↓
  set -g __fish_git_prompt_show_informative_status true
  set -g __fish_git_prompt_showcolorhints true
  set -g __fish_git_prompt_showdirtystate true
  set -g __fish_git_prompt_showuntrackedfiles true
  set -g __fish_git_prompt_showupstream informative

  mise activate fish | source
  batman --export-env | source
end
