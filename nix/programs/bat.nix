{ nixpkgsUnstable }:
{
  enable = true;
  package = nixpkgsUnstable.bat;
  extraPackages = [ nixpkgsUnstable.bat-extras.batman ];
}
