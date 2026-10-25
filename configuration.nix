# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # ./hardware-configuration.nix
      ./desktop.nix
      # ./zen.nix
    #  ./home.nix
    ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
  # systemd.targets.sleep.enable = false;
  # systemd.targets.suspend.enable = false;
  # systemd.targets.hibernate.enable = false;
  # systemd.targets.hybrid-sleep.enable = false;
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
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
 # 1. Override the hardware profile map to explicitly treat the card as a 4-channel output split
 



    # Use the WirePlumber session manager
    # wireplumber.enable = true;
  };
  hardware.alsa.enablePersistence = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
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
  environment.systemPackages = [
    pkgs.pulsemeeter
    inputs.spotifast.packages."${pkgs.stdenv.hostPlatform.system}".default
    pkgs.pre-commit
    pkgs.tmux
    pkgs.bitwarden-desktop
    pkgs.discord
    pkgs.vscode
    pkgs.neovim
    pkgs.kubectl
    pkgs.kubelogin-oidc
    pkgs.omnictl
    pkgs.talosctl
    pkgs.fluxcd
    pkgs.git
    pkgs.pulseaudio
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.hello
    pkgs.pavucontrol 
    pkgs.alsa-utils
    pkgs.qpwgraph
    pkgs.pamixer
    pkgs.bluez
    pkgs.bluez-tools
    pkgs.heroic
    pkgs.steam
    pkgs.tpm-fido
    pkgs.pinentry-all
    pkgs.vault
    pkgs.git-credential-manager
    pkgs.terraform
    pkgs.coder
    pkgs.kubernetes-helm
    pkgs.headlamp
    inputs.prismlauncher.packages.${pkgs.system}.prismlauncher
    pkgs.openshot-qt
    pkgs.karere
    pkgs.twinkle
    pkgs.k9s
    pkgs.xclicker
    pkgs.wineWow64Packages.stable
    pkgs.istioctl
    pkgs.devenv
    # pkgs.tailscale
    ];
  services.tailscale = {
    # Enable tailscale at startup
    enable = true;
  };
    programs.direnv.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  # Install firefox.
  programs.firefox.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = ["harry"];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall.allowedUDPPorts = [ 5353 ];
  networking.firewall.allowedTCPPorts = [ 57621 ];
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
