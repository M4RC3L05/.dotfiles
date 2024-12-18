{ nixpkgsUnstable }:
{
  enable = true;
  package = nixpkgsUnstable.kubecolor;
  enableAlias = true;
}
