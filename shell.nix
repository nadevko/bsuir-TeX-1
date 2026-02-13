{
  mkShell,
  bsuir-tex-shell,

  tex-fmt,
}:
mkShell {
  inputsFrom = [ bsuir-tex-shell ];
  packages = [ tex-fmt ];
}
