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
        treefmtModule = treefmt-nix.lib.evalModule pkgs ./nix/treefmt.nix;
      in
      {
        formatter = treefmtModule.config.build.wrapper;

        checks = {
          formatting = treefmtModule.config.build.check self;
        };

        packages = {
          explore_tf_state = pkgs.writeShellApplication {
            name = "explore_tf_state";

            runtimeInputs = with pkgs; [
              gum
              fzf
              opentofu
              bat
              jq
            ];

            text = builtins.readFile ./explore_tf_state/explore_tf_state.sh;
          };

          plot_loc = pkgs.python3Packages.buildPythonApplication {
            pname = "plot-loc";
            version = "0.1.0";
            pyproject = true;

            src = ./plot_loc;

            build-system = with pkgs.python3Packages; [
              setuptools
            ];

            dependencies = with pkgs.python3Packages; [
              matplotlib
              pygit2
              tqdm
            ];
          };
        };
      }
    );
}
