# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./desktop.nix
    ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;




  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

  };
  hardware.alsa.enablePersistence = true;

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  security.tpm2.tctiEnvironment.enable = true;  # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  boot.kernelModules = [ "uhid" ];  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.tpm_uhid = {};
  users.users."harry" = {
    isNormalUser = true;
    description = "Harry Esses";
    extraGroups = [ "networkmanager" "wheel" "audio" "tss" "tpm_uhid"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };
    services.udev.extraRules = ''
    KERNEL=="uhid", SUBSYSTEM=="misc", GROUP="tpm_uhid", MODE="0660"
  '';
  services.tailscale = {
    enable = true;
  };
    programs.direnv.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  programs.firefox.enable = false;

  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = ["harry"];


  networking.firewall.allowedUDPPorts = [ 5353 ];
  networking.firewall.allowedTCPPorts = [ 57621 ];

  system.stateVersion = "26.05"; # Did you read the comment?

}
