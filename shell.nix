{
  pkgs ? import <nixpkgs> { },
}:
(pkgs.mkShell.override { stdenv = pkgs.stdenvNoCC; }) {
  packages = [
    (pkgs.texliveSmall.withPackages (_: [ (pkgs.callPackage ./nixpkgs/bsuir-tex.nix { }) ]))
    pkgs.python312Packages.pygments
    pkgs.inkscape-with-extensions
  ];
}
