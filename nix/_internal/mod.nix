{ pkgs }:
{
  pkgs = import ./packages/mod.nix { inherit pkgs; };
}
