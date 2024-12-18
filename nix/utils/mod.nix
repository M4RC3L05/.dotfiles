{ lib, pkgs }:
{
  wrap = import ./wrap.nix {
    inherit lib;
    inherit pkgs;
  };
}
