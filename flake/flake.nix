{
  description = "A very basic flake";

  inputs = {
    spotifast.url = "github:crmne/spotifast";
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";

      # Optional: Override the nixpkgs input of prismlauncher to use the same revision as the rest of your flake
      # Note that this may break the reproducibility mentioned above, and you might not be able to access the binary cache
      #
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: To ensure compatibility with the latest Firefox version, use nixpkgs-unstable.
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=release-26.05";
    # unifi-os-server.url = "github:rcambrj/unifi-os-server";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs: {
    packages = builtins.mapAttrs (system: pkgs: {
      hello = pkgs.hello;

      default = inputs.self.packages.${system}.hello;
    }) inputs.nixpkgs.legacyPackages;
    nixosConfigurations.angelica = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; 
      specialArgs = { inherit inputs; }; 
      modules = [
	      ../hardware-configuration-angelica.nix
        ../configuration.nix
        ../bootloader-angelica.nix
        ../assorted-angelica.nix
        ../dev-packages.nix
        ../system-packages.nix
        ../game-packages.nix

        inputs.home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
          home-manager.users.harry = import ../home.nix;
        }
      ];
    };
    nixosConfigurations.elisa = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; 
      specialArgs = { inherit inputs; }; 
      modules = [
        # inputs.unifi-os-server.nixosModules.unifi-os-server
	      ../hardware-configuration-elisa.nix
        ../configuration.nix
        ../bootloader-elisa.nix
        ../assorted-elisa.nix
        # ../unifi-elisa.nix
        # ../zen.nix
        ../dev-packages.nix
        ../system-packages.nix
        ../game-packages.nix
        ../audio-packages.nix
        inputs.home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
          home-manager.users.harry = import ../home.nix;
        }
      ];
    };
    nixosConfigurations.peggy = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; 
      specialArgs = { inherit inputs; }; 
      modules = [
	      ../hardware-configuration-peggy.nix
        ../configuration.nix
        ../bootloader-peggy.nix
        ../assorted-peggy.nix
        ../system-packages.nix
        inputs.home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
          home-manager.users.harry = import ../home.nix;
        }
      ];
    };
    nixosConfigurations.exitnode = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; 
      specialArgs = { inherit inputs; }; 
      modules = [
        # inputs.unifi-os-server.nixosModules.unifi-os-server
	      ../hardware-configuration-exitnode.nix
        ../configuration-exitnode.nix
        ../ssh-exitnode.nix
        # ../bootloader-elisa.nix
        # ../assorted-elisa.nix
        # ../unifi-elisa.nix
        # ../zen.nix

      ];
    };
#  environment.systemPackages = [
#    inputs.self.hello
#  ];
  };
}