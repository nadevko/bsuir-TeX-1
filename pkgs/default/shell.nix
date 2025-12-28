{
  mkShell,
  stdenvNoCC,
  inkscape-with-extensions,
  texlive,
  system,
  inputs,
}:
mkShell.override { stdenv = stdenvNoCC; } {
  packages = [
    (texlive.combine rec {
      inherit (inputs.self.packages.${system}) bsuir-tex;
      inherit (bsuir-tex) tlDeps;
    })
    inkscape-with-extensions
  ];
}
