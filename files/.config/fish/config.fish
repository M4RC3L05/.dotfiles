if status is-interactive
    # Hydro
    set -g hydro_color_pwd green
    set -g hydro_color_prompt magenta
    set -g hydro_color_duration yellow

    # aliases
    alias cat "bat --style=plain"
    alias ls "exa --color=auto --header --git"
    alias code="codium --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto"

    # asdf
    source ~/.asdf/asdf.fish
end
