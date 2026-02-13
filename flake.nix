{
  nixConfig.extra-experimental-features = [
    "pipe-operators"
    "no-url-literals"
  ];

  inputs.nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
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
        apps = import ./overlays/apps.nix;
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
        |> (packages: packages // { default = packages.bsuir-shell; })
      );

      formatter = k.forAllPkgs self { } (pkgs: pkgs.kasumi-fmt);

      apps = k.forAllSystems (
        system:
        nixpkgs.legacyPackages.${system}
        |> k.makeLayer so.environment
        |> k.foldLayerWith [
          so.default
          so.devShells
        ]
        |> k.rebaseLayerTo so.apps
        |> k.collapseSupportedBy system
        |> (apps: apps // { default = apps.bsuir-xelatex; })
        |> builtins.mapAttrs (
          _: v: {
            type = "app";
            program = nixpkgs.lib.getExe v;
          }
        )
      );
    };
}
