{
  description = "Zen Browser Package and Config";

  inputs = {
    
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs }: {
    packages = builtins.mapAttrs (system: pkgs: {
      
      # Define your custom packages here
      hello = pkgs.hello;
      default = self.packages.${system}.hello;

    }) nixpkgs.legacyPackages;
  };
}
