{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
#    ghc = {
#	url = "git+https://gitlab.haskell.org/ghc/ghc.nix";
#    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem = { self', pkgs, system, ... }: {
	#devShells.default = (builtins.trace ghc.devShells ghc.devShells).${system}.js-cross;
	devShells.default = pkgs.mkShell {
	  nativeBuildInputs =  
	    let
	      inherit (pkgs) haskell ghc stdenv cabal-install haskellPackages happy;
	      ghc_stdenv = stdenv.override {
		targetPlatform = stdenv.targetPlatform // {
		  config = "javascript-unknown-ghcjs";
		  isGhcjs = true;
		  isx86 = false;
		  isx86_64 = false;
		  isJavaScript = true;
		};
	      };
	      ghc_js = haskell.compiler.ghc981.override { stdenv = ghc_stdenv; };
	    in [
	      ghc_js
	      ghc
	      cabal-install
	      haskellPackages.happy
	      haskellPackages.alex
	      haskellPackages.cpphs
	      haskellPackages.cabal-plan
	    ];
	};
      };
    }; 
}
