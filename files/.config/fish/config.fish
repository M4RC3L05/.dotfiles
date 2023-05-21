if status is-interactive
    # Hydro
    set -g hydro_color_pwd green
    set -g hydro_color_prompt magenta
    set -g hydro_color_duration yellow

    # aliases
    alias bat="bat --style=plain"
    alias exa="exa --color=auto --header --icons --git"

    # brew config
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
