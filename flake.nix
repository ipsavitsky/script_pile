{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        packageScript = import ./nix/script_create.nix { inherit pkgs; };
        treefmtModule = treefmt-nix.lib.evalModule pkgs ./nix/treefmt.nix;
      in
      {
        formatter = treefmtModule.config.build.wrapper;

        checks = {
          formatting = treefmtModule.config.build.check self;
        };

        packages.explore_tf_state = packageScript {
          filename = "explore_tf_state";
          additionalPkgs = [
            pkgs.gum
            pkgs.fzf
            pkgs.opentofu
            pkgs.bat
            pkgs.jq
          ];
        };
      }
    );
}
