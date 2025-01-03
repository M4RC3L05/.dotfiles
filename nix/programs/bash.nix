{ defaults, pkgs }:
{
  enable = true;
  inherit (defaults) shellAliases;
  bashrcExtra = ''
    export TERM="xterm-256color";

    eval "$(${pkgs.lib.getExe pkgs.bat-extras.batman} --export-env)"
  '';
  initExtra = ''
    # Git prompt
    . ${pkgs.git}/share/git/contrib/completion/git-prompt.sh

    # Prompt
    prompt() {
      local color_red="\001\e[31m\002"
      local color_green='\001\e[32m\002'
      local color_grey='\001\e[37m\002'
      local color_reset='\001\e[0m\002'

      local error="no"
      local exit_statuses=("$@")
      local username="''${USER:-$(whoami)}"
      local hostname="''${HOSTNAME:-$(hostname)}"
      local home="''${HOME:-$(echo ~)}"
      local path="''${PWD:-$(pwd)}"
      path="''${path/#$home/'~'}"
      path="$(echo "$path" | awk -F'/' '{for(i=1;i<NF;i++) printf "%s/", substr($i,1,1); print $NF}')"
      local git_branch="$(__git_ps1 " $color_grey%s$color_reset")"

      echo -en "$color_green$path$color_reset"
      echo -en "$git_branch"

      if [[ -n "$git_branch" ]] && [[ -n "$(git status --porcelain)" ]]; then
        echo -en "*"
      fi

      echo -en " "

      for exit_status in "''${exit_statuses[@]}"; do
        if [[ "$exit_status" != "0" ]]; then
          error="yes"
          break
        fi
      done

      if [[ "$error" == "yes" ]]; then
        local exit_statuses_joined="''${exit_statuses[*]}"
        echo -en "$color_red[''${exit_statuses_joined// / | }]❱$color_reset"
      else
        echo -en "❱"
      fi
    }

    eval "$(mise activate bash)"

    PS1='$(prompt "''${PIPESTATUS[@]}") '

    # Greeting
    the-office-quote
    echo
  '';
}
