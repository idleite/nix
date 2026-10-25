{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = [
    pkgs.pulsemeeter
    pkgs.pulseaudio
    pkgs.pavucontrol 
    pkgs.alsa-utils
    pkgs.qpwgraph
    pkgs.pamixer

    ];

}