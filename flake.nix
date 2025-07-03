{
  description = "OpenTESArena goes flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    riveroverflow = {
      url = "gitlab:akumar-xyz/riveroverflow";
      flake = false;
    };
  };

  outputs = inputs@{ nixpkgs, flake-parts, riveroverflow, ... }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem = {self', pkgs, system, ...}: {
        packages.default = self'.packages.riveroverflow;
        packages.riveroverflow = pkgs.stdenv.mkDerivation {
          pname = "riveroverflow";
          version = "0.0.2";

          src = riveroverflow;

          nativeBuildInputs = with pkgs; [ wayland-scanner pkg-config ];
          buildInputs = [ pkgs.wayland ];

          installFlags = [ "PREFIX=$(out)" ];

        };

      };
    };
}
