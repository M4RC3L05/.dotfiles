{
  defaults,
  pkgs,
  lib,
  internal,
}:
{
  enable = true;
  inherit (defaults) shellAliases;
  generateCompletions = true;
  functions = {
    fish_greeting = ''
      ${lib.getExe internal.pkgs.theOfficeQuote}
      echo
    '';
  };
  interactiveShellInit = ''
    set -g __fish_git_prompt_char_upstream_ahead ↑
    set -g __fish_git_prompt_char_upstream_behind ↓
    set -g __fish_git_prompt_show_informative_status true
    set -g __fish_git_prompt_showcolorhints true
    set -g __fish_git_prompt_showdirtystate true
    set -g __fish_git_prompt_showuntrackedfiles true
    set -g __fish_git_prompt_showupstream informative
  '';
}
