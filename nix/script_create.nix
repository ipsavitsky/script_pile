{ pkgs }:
{
  scriptname,
  filename,
  additionalPkgs,
}:
pkgs.symlinkJoin {
  name = filename;
  paths =
    let
      script = (pkgs.writeScriptBin scriptname (builtins.readFile ../${filename})).overrideAttrs (old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
      });
    in
    [ script ] ++ additionalPkgs;
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${scriptname} --prefix PATH : $out/bin";
}
