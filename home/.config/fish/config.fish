status is-login; and begin
  # Login shell initialisation
end

status is-interactive; and begin
  # Aliases
  alias cat "bat --plain"
  alias eza "eza --icons auto --color auto --git"
  alias ls eza
  alias proxyK8sServer "ssh -NL 6443:127.0.0.1:6443 mainserver"
  alias kubectl kubecolor

  # Interactive shell initialisation
  set -g __fish_git_prompt_char_upstream_ahead ↑
  set -g __fish_git_prompt_char_upstream_behind ↓
  set -g __fish_git_prompt_show_informative_status true
  set -g __fish_git_prompt_showcolorhints true
  set -g __fish_git_prompt_showdirtystate true
  set -g __fish_git_prompt_showuntrackedfiles true
  set -g __fish_git_prompt_showupstream informative

  source "$HOME"/.nix-profile/etc/profile.d/nix.fish

  batman --export-env | source
end
