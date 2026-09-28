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
            version = "main";

            src = pkgs.fetchFromGitHub {
              owner = "dslapelis";
              repo = "linuxmeeter";
              rev = "main"; 
              hash = "sha256-EWb8MGcQfyysXcQUiF32won4a5b8+OVLWylmdyMRTD0="; 
            };

            cargoHash = "sha256-psLXl/PrgLnKJ6dyVjE4fZorEUhu/YBpm2jCdLa4szU=";

            pnpmDeps = pkgs.fetchPnpmDeps {
              fetcherVersion = 4;
              inherit pname version src;
              hash = "sha256-Vg7kJ+kzLVQtgrB0FTelE1ed2p0Xbd0wmTi0CHpSeig=";
            };

            nativeBuildInputs = with pkgs; [
              pnpm
              pkg-config
              wrapGAppsHook3
              rustPlatform.bindgenHook
              nodejs
              pnpmConfigHook
              cargo-tauri
            ];

            buildInputs = with pkgs; [
              glib
              gtk3
              webkitgtk_4_1
              libayatana-appindicator
              pipewire
              lsp-plugins
            ];

            preBuild = ''
              echo "Building frontend assets..."
              pnpm build
            '';

            buildPhase = ''
              runHook preBuild
              echo "Building Tauri application..."
              cargo-tauri build --no-bundle --target ${pkgs.stdenv.hostPlatform.rust.rustcTarget}
              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall
              mkdir -p $out/bin
              cp target/${pkgs.stdenv.hostPlatform.rust.rustcTarget}/release/linuxmeeter $out/bin/
              runHook postInstall
            '';

            preFixup = ''
              gappsWrapperArgs+=(
                --prefix LV2_PATH : "${pkgs.lsp-plugins}/lib/lv2"
                --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [ pkgs.libayatana-appindicator ]}"
                --set WEBKIT_DISABLE_DMABUF_RENDERER "1"
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
              webkitgtk_4_1
              libayatana-appindicator
              pipewire
              lsp-plugins
            ];

            shellHook = ''
              export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath (with pkgs; [ pipewire gtk3 webkitgtk_4_1 libayatana-appindicator ])}:$LD_LIBRARY_PATH
              export LV2_PATH="${pkgs.lsp-plugins}/lib/lv2"
            '';
          };
        });
    };
}