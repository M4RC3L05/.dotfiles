{ nixpkgsUnstable }:
{
  enable = true;
  package = nixpkgsUnstable.eza;
  git = true;
  icons = "auto";
  colors = "auto";
}
