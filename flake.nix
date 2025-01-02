{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      packageScript = import ./script_create.nix { inherit pkgs; };
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt-rfc-style;

      packages.x86_64-linux.explore_tf_state = packageScript {
        filename = "explore_tf_state";
        additionalPkgs = [
          pkgs.gum
          pkgs.fzf
          pkgs.opentofu
        ];
      };
    };
}
