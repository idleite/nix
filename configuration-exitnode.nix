{ config, pkgs, ... }:

{


  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/sda";
  # boot.loader.grub.useOSProber = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "exitnode"; # Define your hostname.


  # Enable networking
  networking.networkmanager.enable = true;

  # # Set your time zone.
  time.timeZone = "America/New_York";

  # # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nix.settings.trusted-users = ["harry"];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."harry" = {
    isNormalUser = true;
    description = "harry";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
  networking = {
    nameservers = [ "1.1.1.1" "1.0.0.1"];
    networkmanager.dns = "none";
    interfaces.ens18 = {
      ipv4.addresses = [{
        address = "10.20.1.11";
        prefixLength = 16;
      }];
    };
    defaultGateway = {
      address = "10.20.1.0";
      interface = "ens18";
    };

  };
  services.tailscale = {
    # Enable tailscale at startup
    enable = true;
    # authKeyParameters.baseURL = "https://headscale.harryesses.com";
    extraUpFlags = [ 
      "--login-server=https://headscale.harryesses.com"
      "-reset"
      "--advertise-exit-node=true"
      "--advertise-routes=10.20.0.0/16"

    ];
    useRoutingFeatures = "server";
    # If you would like to use a preauthorized key, set
    authKeyFile = "/home/harry/headscale_key";
    # Note: maximum expire time is 90 days
  };
  services.networkd-dispatcher = {
    enable = true;
    rules."50-tailscale-optimizations" = {
      onState = [ "routable" ];
      script = ''
        ${pkgs.ethtool}/bin/ethtool -K ens18 rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = false;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    ethtool
  ];




  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
