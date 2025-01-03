{ defaults, pkgs }:
{
  enable = true;
  inherit (defaults) shellAliases;
  functions = {
    fish_greeting = "the-office-quote; echo";
  };
  interactiveShellInit = ''
    set -g hydro_color_pwd green
    set -g hydro_color_prompt magenta
    set -g hydro_color_duration yellow

    mise activate fish | source
  '';
  plugins = [
    {
      name = "hydro";
      inherit (pkgs.fishPlugins.hydro) src;
    }
  ];
}
