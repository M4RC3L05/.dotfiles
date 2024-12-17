{ nixpkgsUnstable }:
{
  enable = true;
  package = nixpkgsUnstable.mise;
  enableBashIntegration = true;
  enableFishIntegration = true;
  globalConfig = {
    tools = {
      usage = "latest";
    };
  };
}
