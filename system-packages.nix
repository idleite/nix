{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = [
    pkgs.bluez
    pkgs.bluez-tools
    pkgs.bitwarden-desktop
    pkgs.discord
    pkgs.karere
    pkgs.twinkle
    pkgs.wineWow64Packages.stable
    pkgs.tpm-fido
    pkgs.pinentry-qt
    inputs.spotifast.packages."${pkgs.stdenv.hostPlatform.system}".default

    ];

}