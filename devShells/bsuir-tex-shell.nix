{
  mkShell,

  texliveMedium,
  inkscape,
  python3Packages,
  texlivePackages,
}:
mkShell {
  packages = [
    (texliveMedium.withPackages (_: [ texlivePackages.bsuir-tex ] ++ texlivePackages.bsuir-tex.tlDeps))
    inkscape
    python3Packages.pygments
  ];
}
