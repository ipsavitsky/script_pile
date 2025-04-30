{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      uv2nix,
      pyproject-nix,
      pyproject-build-systems,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        treefmtModule = treefmt-nix.lib.evalModule pkgs ./nix/treefmt.nix;
        workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./plot_loc; };
        overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };
        pythonSet = (pkgs.callPackage pyproject-nix.build.packages {
          python = pkgs.python312;
        }).overrideScope (
          pkgs.lib.composeManyExtensions [
            pyproject-build-systems.overlays.default
            overlay
          ]
        );
      in
      {
        formatter = treefmtModule.config.build.wrapper;

        checks = {
          formatting = treefmtModule.config.build.check self;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ uv python3 ];
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

          plot_loc = pythonSet.mkVirtualEnv "plot_loc" workspace.deps.default;
        };
      }
    );
}
