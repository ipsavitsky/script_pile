{
  symlinkJoin,
  writeScriptBin,
  makeWrapper,
}:
{ filename }:
symlinkJoin {
  name = filename;
  paths = [
    (writeScriptBin filename (builtins.readFile ./${filename}))
  ];
}
