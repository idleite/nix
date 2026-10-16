{ config, pkgs, inputs, ... }:

{
  virtualisation.docker.enable = true;
  networking.hostName = "elisa"; # Define your hostname.

}