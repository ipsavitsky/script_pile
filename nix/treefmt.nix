_: {
  projectRootFile = "flake.nix";
  programs.nixfmt.enable = true;
  programs.statix.enable = true;
  programs.deadnix.enable = true;
  programs.shfmt.enable = true;
  programs.shellcheck.enable = true;
}
