{ defaults, pkgs }:
{
  enable = true;
  package = pkgs.fish;
  shellAliases = defaults.shellAliases;
  functions = {
    fish_greeting = "the-office-quote; echo";
  };
  interactiveShellInit = ''
    set -g hydro_color_pwd green
    set -g hydro_color_prompt magenta
    set -g hydro_color_duration yellow
  '';
  plugins = [
    {
      name = "hydro";
      src = pkgs.fishPlugins.hydro.src;
    }
  ];
}
