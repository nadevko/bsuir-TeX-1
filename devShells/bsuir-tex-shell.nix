{
  mkShell,

  texliveFull,
  inkscape,
  python3Packages,
}:
mkShell {
  packages = [
    texliveFull
    inkscape
    python3Packages.pygments
  ];
}
