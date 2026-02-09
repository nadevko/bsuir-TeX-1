{
  mkShell,
  texliveMedium,
  tex-fmt,
  inkscape,
  python3Packages,
  texlivePackages,
}:
mkShell {
  packages = [
    (texliveMedium.withPackages (_: [ texlivePackages.bsuir-tex ] ++ texlivePackages.bsuir-tex.tlDeps))
    tex-fmt
    inkscape
    python3Packages.pygments
  ];
}
