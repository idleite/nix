{ config, pkgs, inputs, ... }:

{
  networking.hostName = "peggy"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  services.libinput.enable = true;

}