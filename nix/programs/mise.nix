{ pkgs }:
{
  enable = true;
  package = pkgs.mise;
  enableBashIntegration = true;
  enableFishIntegration = true;
  globalConfig = {
    tools = {
      usage = "latest";
    };
  };
}
