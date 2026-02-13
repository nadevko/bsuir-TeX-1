final: _: {
  bsuir-tex-shell = final.callPackage ../devShells/bsuir-tex-shell.nix { };
  bsuir-shell = final.callPackage ../shell.nix { };
}
