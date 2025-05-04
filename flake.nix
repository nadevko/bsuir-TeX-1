{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
  inputs.mkflake.url = "github:jonascarpay/mkflake";

  outputs =
    {
      self,
      nixpkgs,
      mkflake,
    }:
    mkflake.lib.mkflake {
      topLevel.overlays.default = final: prev: { texlivePackages.bsuir-tex = prev.callPackage ./. { }; };

      perSystem = system: {
        devShells.default =
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          (pkgs.mkShell.override { stdenv = pkgs.stdenvNoCC; }) {
            packages = [
              (pkgs.texliveSmall.withPackages (_: [ self.packages.${system}.default ]))
              pkgs.python312Packages.pygments
              pkgs.inkscape-with-extensions
            ];
          };
        packages = {
          texlivePackages.bsuir-tex =
            (nixpkgs.legacyPackages.${system}.extend self.overlays.default).texlivePackages.bsuir-tex;
          default = self.packages.${system}.texlivePackages.bsuir-tex;
        };
        formatter = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
      };
    };
}
