{
  mkShell,
  texliveMedium,
  tex-fmt,
  inkscape-with-extensions,
  python3Packages,
  texlivePackages,
}:
mkShell {
  packages = [
    (texliveMedium.withPackages (
      ps:
      with ps;
      [
        texlivePackages.bsuir-tex
        makecell
        breqn
        pgfplots
      ]
      ++ texlivePackages.bsuir-tex.tlDeps
    ))
    tex-fmt
    inkscape-with-extensions
    python3Packages.pygments
  ];
}
