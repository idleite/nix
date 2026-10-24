{
  description = "NixOS Flake for passkeyd WebAuthn Authenticator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      # Systems you want to support
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.passkeyd = pkgs.rustPlatform.buildRustPackage rec {
          pname = "passkeyd";
          version = "1.9.3"; # Replace with the correct target tag or version string

          src = pkgs.fetchFromGitHub {
            owner = "bjn7";
            repo = "passkeyd";
            rev = "v${version}"; 
            # Leave this hash blank initially; Nix will throw an error 
            # showing the correct hash to paste here on the first run.
            hash = "sha256-If7SLL2CBu1Bzt4Ou93WONBgHq3MJpgCseAAY+BjRZA=";
          };

          # Passkeyd utilizes Cargo.lock for managing Rust dependencies
          cargoHash = pkgs.lib.fakeHash;

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          buildInputs = with pkgs; [
            openssl
            dbus
            pcsclite # Needed if utilizing external smartcard/hardware configurations
          ];

          meta = with pkgs.lib; {
            description = "An opinionated WebAuthn Authenticator daemon for Linux";
            homepage = "https://github.com/bjn7/passkeyd";
            license = licenses.gpl3Only;
            platforms = platforms.linux;
          };
        };

        defaultPackage = self.packages.${system}.passkeyd;
      }) // {
        
        # NixOS system module output to run passkeyd as a background daemon
        nixosModules.default = { config, lib, pkgs, ... }:
          let
            cfg = config.services.passkeyd;
            # Grab the package for the evaluating system architecture
            passkeydPkg = self.packages.${pkgs.stdenv.hostPlatform.system}.passkeyd;
          in {
            options.services.passkeyd = {
              enable = lib.mkEnableOption "passkeyd WebAuthn background service";
            };

            config = lib.mkIf cfg.enable {
              environment.systemPackages = [ passkeydPkg ];

              # Registers the DBus service or background daemon rules
              systemd.services.passkeyd = {
                description = "passkeyd WebAuthn Daemon";
                after = [ "network.target" "dbus.socket" ];
                wantedBy = [ "multi-user.target" ];
                serviceConfig = {
                  ExecStart = "${passkeydPkg}/bin/passkeyd";
                  Restart = "always";
                  # Hardening mechanisms
                  ProtectSystem = "full";
                  PrivateTmp = true;
                };
              };
            };
          };
      };
}
