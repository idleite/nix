{ config, pkgs, inputs, ... }:

{
  networking.hostName = "angelica"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

}