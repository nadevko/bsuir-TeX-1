{
  nixConfig.extra-experimental-features = [
    "pipe-operators"
    "no-url-literals"
  ];

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.kasumi = {
    url = "github:nadevko/kasumi";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      kasumi,
      nixpkgs,
    }:
    let
      so = self.overlays;
      k = kasumi.lib;
      ko = kasumi.overlays;
    in
    {
      overlays = {
        default = import ./overlay.nix;
        devShells = import ./overlays/devShells.nix;
        environment = k.foldLay [
          ko.augment
          ko.compat
          ko.default
        ];
      };

      packages = k.forAllSystems (
        system:
        nixpkgs.legacyPackages.${system}
        |> k.makeLayer so.environment
        |> k.rebaseLayerTo so.default
        |> k.collapseSupportedBy system
        |> (packages: packages // { default = packages.bsuir-tex; })
      );

      legacyPackages = k.importPkgsForAll nixpkgs {
        overlays = [
          so.environment
          so.default
          so.devShells
        ];
      };

      devShells = k.forAllSystems (
        system:
        self.legacyPackages.${system}
        |> k.makeLayer so.devShells
        |> k.collapseSupportedBy system
        |> (packages: packages // { default = packages.bsuir-tex-shell; })
      );

      formatter = k.forAllPkgs self { } (pkgs: pkgs.kasumi-fmt);
    };
}
