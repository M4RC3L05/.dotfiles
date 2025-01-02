{ pkgs }:
{
  enable = true;
  package = pkgs.bat;
  extraPackages = [ pkgs.bat-extras.batman ];
}
