{ pkgs }:
{
  theOfficeQuote = pkgs.callPackage ./the-office-quote.nix { inherit pkgs; };
  denotag = pkgs.callPackage ./denotag.nix { inherit pkgs; };
}
