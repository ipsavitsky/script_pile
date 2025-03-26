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

        packages = {
          explore_tf_state = packageScript {
            filename = "explore_tf_state/explore_tf_state.sh";
            scriptname = "explore_tf_state";
            additionalPkgs = with pkgs; [
              gum
              fzf
              opentofu
              bat
              jq
            ];
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
