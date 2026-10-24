
{ config, lib, pkgs, ... }:

let
  cfg = config.services.linux-id;

  linuxId = pkgs.callPackage ./package.nix { };

  authArgs =
    lib.optionalString (cfg.auth == "fprintd") " --auth fprintd";
in
{
  options.services.linux-id = {
    enable = lib.mkEnableOption
      "the linux-id TPM-backed FIDO authenticator";

    package = lib.mkOption {
      type = lib.types.package;
      default = linuxId;
      defaultText = lib.literalExpression
        "pkgs.callPackage ./package.nix {}";
      description = "The linux-id package to run.";
    };

    auth = lib.mkOption {
      type = lib.types.enum [ "pinentry" "fprintd" ];
      default = "pinentry";
      description = ''
        Authentication method. pinentry requests a confirmation dialog;
        fprintd requests fingerprint verification.
      '';
    };

    enableUserService = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable linux-id.service in the default target of user
        systemd instances.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.boot.kernelPackages != null;
        message = "linux-id requires a Linux kernel.";
      }
    ];

    boot.kernelModules = [ "uhid" ];

    services.fprintd.enable =
      lib.mkIf (cfg.auth == "fprintd") true;

    environment.systemPackages = [
      cfg.package
    ] ++ lib.optionals (cfg.auth == "pinentry") [
      pkgs.pinentry-qt
    ];

    services.udev.extraRules = ''
      # Grant the active desktop user access to the TPM and UHID.
      KERNEL=="uhid", SUBSYSTEM=="misc", TAG+="uaccess"
      KERNEL=="tpmrm0", SUBSYSTEM=="tpmrm", TAG+="uaccess"
    '';

    systemd.user.services.linux-id = lib.mkIf cfg.enableUserService {
      description = "linux-id TPM-backed FIDO service";
      documentation = [
        "https://github.com/matejsmycka/linux-id"
      ];

      wantedBy = [ "default.target" ];

      unitConfig = {
        ConditionSecurity = "tpm2";
        ConditionKernelModuleLoaded = "uhid";
      };

      serviceConfig = {
        Type = "simple";

        ExecStart =
          "${cfg.package}/bin/linux-id${authArgs}";

        Restart = "on-failure";
        RestartSec = "2s";

        ProtectProc = "noaccess";
        ProtectSystem = "strict";
        PrivateTmp = true;
        PrivateNetwork = true;
        PrivatePIDs = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_UNIX" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        NoNewPrivileges = true;

        BindReadOnlyPaths = [
          "%t"
          "%T/.X11-unix"
        ];

        DevicePolicy = "closed";
        DeviceAllow = [
          "/dev/tpmrm0 rw"
          "/dev/uhid rw"
        ];
      };
    };
  };
}
