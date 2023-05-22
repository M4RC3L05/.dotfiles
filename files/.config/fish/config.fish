if status is-interactive
    # Hydro
    set -g hydro_color_pwd green
    set -g hydro_color_prompt magenta
    set -g hydro_color_duration yellow

    # aliases
    alias bat="bat --style=plain"
    alias exa="exa --color=auto --header --icons --git"

    # asdf
    source ~/.asdf/asdf.fish
end
