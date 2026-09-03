{
  description = "A very basic flake";

  inputs = {
    zen.url = "path:zen";
    nixpkgs.url = "github:nixos/nixpkgs?ref=release-26.05";
  };

  outputs = inputs: {
    packages = builtins.mapAttrs (system: pkgs: {
      hello = pkgs.hello;

      default = inputs.self.packages.${system}.hello;
    }) inputs.nixpkgs.legacyPackages;
    nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; 
      specialArgs = { inherit inputs; }; 
      modules = [
	      ../hardware-configuration.nix
        ../configuration.nix
        ../zen.nix
      ];
    };
#  environment.systemPackages = [
#    inputs.self.hello
#  ];
  };
}