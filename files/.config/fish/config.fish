if status is-interactive
    # Hydro
    set -g hydro_color_pwd green
    set -g hydro_color_prompt magenta
    set -g hydro_color_duration yellow

    # aliases
    alias cat "bat --style=plain"
    alias ls "exa --color=auto --header --git"
    alias code="codium --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto"
    alias prime-run "__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only"

    # asdf
    source ~/.asdf/asdf.fish
end
