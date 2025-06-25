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
        runtimePackages = with pkgs; [
          gum
          fzf
          opentofu
          bat
          jq
        ];
      in
      {
        formatter = treefmtModule.config.build.wrapper;

        checks = {
          formatting = treefmtModule.config.build.check self;
        };

        devShells.default = pkgs.mkShell {
          packages = runtimePackages;
        };

        packages = {
          explore_tf_state = pkgs.writeShellApplication {
            name = "explore_tf_state";
            runtimeInputs = runtimePackages;
            text = builtins.readFile ./explore_tf_state/explore_tf_state.sh;
          };

          wl-screenshot = pkgs.writeShellApplication {
            name = "wl-screenshot";
            runtimeInputs = with pkgs; [
              grim
              slurp
              wl-clipboard
            ];
            text = ''grim -g "$(slurp)" - | wl-copy'';
          };
        };
      }
    );
}
