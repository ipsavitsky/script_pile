{ ... }:
{
  projectRootFile = "flake.nix";
  programs.nixfmt.enable = true;
  programs.shfmt.enable = true;
  programs.shellcheck.enable = true;
  programs.taplo.enable = true;
  programs.isort.enable = true;
  programs.ruff-format.enable = true;
  programs.ruff-check.enable = true;
}
