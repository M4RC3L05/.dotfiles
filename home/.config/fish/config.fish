if status is-interactive
  # hydro
  set -g hydro_color_pwd green
  set -g hydro_color_prompt magenta
  set -g hydro_color_duration yellow

  # binary paths
  fish_add_path ~/AppImages
  fish_add_path ~/.local/bin

  # aliases
  alias cat "bat --plain"
  alias ls "eza --color=auto --header --git --icons"
  alias prime-run "__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only"
  alias yay "without_user_paths yay"
  alias pacman "without_user_paths pacman"
  alias apt "without_user_paths apt"

  # brew
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
