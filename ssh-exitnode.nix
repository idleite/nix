{ config, pkgs,  ... }:

{
    users.users."harry".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARjSzTnOinmI2xuVpcAoV29WO2amH/PKKO53oJIxsxC" # content of authorized_keys file

    ];
    services.openssh = {
        enable = true;
        openFirewall = true;
        # require public key authentication for better security
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          AllowUsers = [ "harry" ];
          MaxAuthTries = 3;
          PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
        };
    };
}