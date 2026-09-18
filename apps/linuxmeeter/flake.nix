{
  description = "LinuxMeeter - VoiceMeeter-style virtual audio mixer for Linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.rustPlatform.buildRustPackage rec {
            pname = "linuxmeeter";
            version = "main"; # Or replace with a specific tag

            src = pkgs.fetchFromGitHub {
              owner = "dslapelis";
              repo = "linuxmeeter";
              rev = "main"; 
              # 1. Nix will complain about this hash on your first run.
              hash = pkgs.lib.fakeHash; 
            };

            # 3. Update this hash third.
            cargoHash = pkgs.lib.fakeHash;

            # Fetch frontend pnpm dependencies offline
            pnpmDeps = pkgs.fetchpnpmDeps {
              inherit pname version src;
              # 2. Update this hash second.
              hash = pkgs.lib.fakeHash;
            };

            nativeBuildInputs = with pkgs; [
              pkg-config
              wrapGAppsHook3       # Ensures GTK/Glib environments are set up
              rustPlatform.bindgenHook # Often needed for PipeWire C-bindings
              nodejs
              pnpm.configHook      # Prepares node_modules dynamically
              cargo-tauri
            ];

            buildInputs = with pkgs; [
              glib
              gtk3
              webkit2gtk_4_1
              libayatana-appindicator
              pipewire
              lsp-plugins
            ];

            # Build the frontend assets before cargo compiles the Rust backend
            preBuild = ''
              echo "Building frontend..."
              pnpm build
            '';

            # Ensure the LV2 plugins are available to PipeWire at runtime
            preFixup = ''
              gappsWrapperArgs+=(
                --prefix LV2_PATH : "${pkgs.lsp-plugins}/lib/lv2"
              )
            '';

            meta = with pkgs.lib; {
              description = "A VoiceMeeter-style virtual audio mixer for Linux, built natively on PipeWire";
              homepage = "https://github.com/dslapelis/linuxmeeter";
              license = licenses.gpl3Only;
              platforms = platforms.linux;
              mainProgram = "linuxmeeter";
            };
          };
        });

      # Provides a shell if you just want to develop/build it locally using `nix develop`
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              pkg-config
              rustPlatform.bindgenHook
              nodejs
              pnpm
              cargo-tauri
              rustc
              cargo
            ];

            buildInputs = with pkgs; [
              gtk3
              glib
              webkit2gtk_4_1
              libayatana-appindicator
              pipewire
              lsp-plugins
            ];

            shellHook = ''
              export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath (with pkgs; [ pipewire gtk3 webkit2gtk_4_1 libayatana-appindicator ])}:$LD_LIBRARY_PATH
              export LV2_PATH="${pkgs.lsp-plugins}/lib/lv2"
            '';
          };
        });
    };
}