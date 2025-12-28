{
  mkShell,
  stdenvNoCC,
  texliveSmall,
  python312Packages,
  inkscape-with-extensions,
  inputs,
}:
mkShell.override { stdenv = stdenvNoCC; } {
  packages = [
    (texliveSmall.withPackages (_: [
      inputs.self.packages.${stdenvNoCC.hostPlatform.system}.bsuir-tex
    ]))
    python312Packages.pygments
    inkscape-with-extensions
  ];
}
