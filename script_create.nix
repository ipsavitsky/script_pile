{ pkgs }:
{ filename, additionalPkgs }:
pkgs.symlinkJoin {
  name = filename;
  paths =
    let
      script = (pkgs.writeScriptBin filename (builtins.readFile ./${filename}.sh)).overrideAttrs (old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
      });
    in
    [ script ] ++ additionalPkgs;
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/${filename} --prefix PATH : $out/bin";
}
