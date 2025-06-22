{
  inputs = {
    haskellNix.url = "github:input-output-hk/haskell.nix";
    nixpkgs.follows = "haskellNix/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, haskellNix, ... }:
      flake-utils.lib.eachDefaultSystem (system:
        let
          compilers = [ "ghc96" "ghc98" "ghc910" "ghc912" ];
          defaultCompiler = "ghc98";
          inherit (pkgs) lib;

          overlays = [
            haskellNix.overlay
          ];

          pkgs = import nixpkgs {
            inherit system overlays;
            inherit (haskellNix) config;
          };

          project = pkgs.haskell-nix.cabalProject' ({ config, ... }: {
            src = pkgs.fetchFromGitHub {
              owner = "haskell";
              repo = "haskell-language-server";
              rev = "0a9b1cb3ed772e52904e6b5ed6e6f2b2134dfb03";
              sha256 = "sha256-NPOfwxpMFyqXQwpjLQCC4dsyB7z7tVeMRdwpBTb8aLo=";
            };

            compiler-nix-name = lib.mkDefault defaultCompiler;

            flake.variants = lib.genAttrs compilers (compiler: {
              compiler-nix-name = lib.mkForce compiler;
            });

            # Benchmark does not build on GHC-9.12+
            configureArgs = 
              lib.optionalString 
                (lib.hasPrefix "ghc912" config.compiler-nix-name) 
                "--disable-benchmarks";

            evalSystem = "x86_64-linux";
          });

          flake = project.flake {};
        in flake // {
          legacyPackages = pkgs;
          packages.project = project;
      });

  nixConfig = {
    extra-substituters = ["https://cache.iog.io"];
    extra-trusted-public-keys = ["hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="];
    allow-import-from-derivation = "true";
  };
}
