
{
  description = "NixOS package and module for linux-id";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          linux-id = pkgs.callPackage ./package.nix { };
          default = self.packages.${system}.linux-id;
        });

      nixosModules.default = import ./module.nix;
      nixosModules.linux-id = self.nixosModules.default;
    };
}
