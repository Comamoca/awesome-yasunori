{
  description = "A curated list of awesome yasunori";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{
      self,
      systems,
      nixpkgs,
      treefmt-nix,
      flake-parts,
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ treefmt-nix.flakeModule ];
      systems = import inputs.systems;

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        let
          stdenv = pkgs.stdenv;
          yasunori = stdenv.mkDerivation {
            pname = "executable";
            version = "0.0.1";
            src = ./.;

            buildPhase = ''
              mkdir $out
            '';

            installPhase = '''';
          };
        in
        rec {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              taplo.enable = true;
            };

            settings.formatter = { };
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nil
            ];
          };

          packages.default = yasunori;
        };
    };
}
