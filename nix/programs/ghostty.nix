{ config, pkgs }:
{
  enable = true;
  package = config.lib.nixGL.wrappers.mesa pkgs.ghostty;
  settings = {
    font-family = "Cascadia Code";
    command = "fish";
    font-size = "10";
    theme = "light:vs_light_modern,dark:vs_dark_modern";
    term = "xterm-256color";
  };
  themes = {
    vs_dark_modern = {
      background = "181818";
      cursor-color = "ffffff";
      foreground = "cccccc";
      palette = [
        "0=#000000"
        "1=#cd3131"
        "2=#0dbc79"
        "3=#e5e510"
        "4=#2472c8"
        "5=#bc3fbc"
        "6=#11a8cd"
        "7=#e5e5e5"
        "8=#666666"
        "9=#f14c4c"
        "10=#23d18b"
        "11=#f5f543"
        "12=#3b8eea"
        "13=#d670d6"
        "14=#29b8db"
        "15=#e5e5e5"
      ];
      selection-background = "264f78";
      # selection-foreground = "ff0000";
    };
    vs_light_modern = {
      background = "f8f8f8";
      cursor-color = "005fb8";
      foreground = "3b3b3b";
      palette = [
        "0=#000000"
        "1=#cd3131"
        "2=#107c10"
        "3=#949800"
        "4=#0451a5"
        "5=#bc05bc"
        "6=#0598bc"
        "7=#555555"
        "8=#666666"
        "9=#cd3131"
        "10=#14ce14"
        "11=#b5ba00"
        "12=#0451a5"
        "13=#bc05bc"
        "14=#0598bc"
        "15=#a5a5a5"
      ];
      selection-background = "add6ff";
      # selection-foreground = "ff0000";
    };
  };
}
