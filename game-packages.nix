{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = [
    pkgs.heroic
    pkgs.steam
    inputs.prismlauncher.packages.${pkgs.system}.prismlauncher
    ];

}