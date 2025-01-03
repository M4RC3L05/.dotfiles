{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.nixfmt-rfc-style
    pkgs.shfmt
    pkgs.shellcheck
    pkgs.editorconfig-checker
    pkgs.jsonfmt
    pkgs.statix
    pkgs.deadnix
  ];
}
