{
  description = "A very basic flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    nixgl = {
      url = "github:nix-community/nixgl";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
  };

  outputs =
    inputs:
    let
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        overlays = [ inputs.nixgl.overlay ];
      };
    in
    {
      defaultPackage.x86_64-linux = pkgs.home-manager;

      homeConfigurations = {
        "main" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ ./nix/home.nix ];
        };
      };

      devShells = {
        x86_64-linux = {
          default = pkgs.mkShell {
            packages = [
              pkgs.nixfmt-rfc-style
              pkgs.shfmt
              pkgs.shellcheck
              pkgs.editorconfig-checker
              pkgs.jsonfmt
              pkgs.statix
              pkgs.deadnix
            ];
          };
        };
      };
    };
}
