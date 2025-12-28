{
  mkShell,
  stdenvNoCC,
  inkscape-with-extensions,
  texliveSmall,
  inputs,
}:
let
  inherit (inputs.self.packages.${stdenvNoCC.hostPlatform.system}) bsuir-tex;
in
mkShell.override { stdenv = stdenvNoCC; } {
  packages = [
    (texliveSmall.withPackages (ps: bsuir-tex.tlDeps ++ (with ps;[ scrhack bsuir-tex ])))
    inkscape-with-extensions
  ];
}
