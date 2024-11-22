{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      packageScript = pkgs.callPackage ./script_create.nix { };
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt-rfc-style;

      packages.x86_64-linux.get_aws_creds = packageScript {
        filename = "get_aws_creds";
      };

      packages.x86_64-linux.explore_tf_state = packageScript {
        filename = "explore_tf_state";
      };

      packages.x86_64-linux.updater = packageScript {
        filename = "updater";
      };
    };
}
