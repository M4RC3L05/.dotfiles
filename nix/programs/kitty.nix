{ config, pkgs }:
{
  enable = true;
  package = (config.lib.nixGL.wrappers.mesa pkgs.kitty);
  shellIntegration = {
    mode = "disabled";
  };
  font = {
    name = "Cascadia Code PL";
    size = 10;
  };
  themeFile = "VSCode_Dark";
  settings = {
    shell = "fish";
  };
}
