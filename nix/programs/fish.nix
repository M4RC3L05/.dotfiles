{
  defaults,
  pkgs,
  lib,
  internal,
}:
{
  enable = true;
  inherit (defaults) shellAliases;
  functions = {
    fish_greeting = ''
      ${lib.getExe internal.pkgs.theOfficeQuote}
      echo
    '';
  };
  interactiveShellInit = ''
    set -g hydro_color_pwd green
    set -g hydro_color_prompt magenta
    set -g hydro_color_duration yellow
  '';
  plugins = [
    {
      name = "hydro";
      inherit (pkgs.fishPlugins.hydro) src;
    }
  ];
}
