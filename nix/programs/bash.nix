{
  defaults,
  pkgs,
  internal,
  lib,
}:
{
  enable = true;
  inherit (defaults) shellAliases;
  enableCompletion = true;
  enableVteIntegration = true;
  initExtra = ''
    export TERM="xterm-256color";

    eval "$(${pkgs.lib.getExe pkgs.bat-extras.batman} --export-env)"

    # Git prompt
    . ${pkgs.git}/share/git/contrib/completion/git-prompt.sh

    # Prompt
    exit_status() {
      local exit_statuses=("$@")

      for exit_status in "''${exit_statuses[@]}"; do
        if [[ "$exit_status" != "0" ]]; then
          local exit_statuses_joined="''${exit_statuses[*]}"
          echo -en " \e[31m[''${exit_statuses_joined// / | }]\e[0m"

          break
        fi
      done
    }

    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    GIT_PS1_SHOWCOLORHINTS="true"
    GIT_PS1_SHOWUPSTREAM="verbose"
    PS1='[\[\033[92m\]\u\[\033[0m\]@\h \[\033[32m\]\w\[\033[0m\]$(__git_ps1 " (%s)")$(exit_status "''${PIPESTATUS[@]}")]$ '

    # Greeting
    ${lib.getExe internal.pkgs.theOfficeQuote}
    echo
  '';
}
