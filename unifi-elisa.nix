{ config, pkgs, inputs, ... }:

{
        
          virtualisation.podman.enable = true;
          virtualisation.oci-containers.backend = "podman";

          services.unifi-os-server = {
            enable = true;
            uosSystemIP = "10.10.1.85";
            openFirewallUiPort = true;
            openFirewallServicePorts = true;
          };
        

}