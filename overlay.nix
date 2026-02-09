final: prev: {
  texlivePackages = prev.texlivePackages // {
    bsuir-tex = final.callPackage ./package.nix { };
  };
}
