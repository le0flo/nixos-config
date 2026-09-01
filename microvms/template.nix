{config, lib, microvm, pkgs, serviceName, ...}:

let
  inherit (builtins)
    concatStringsSep
    filter
    hashString
    length
    substring
    tail;

  inherit (lib)
    hasPrefix
    mkForce
    mkIf
    splitString;

  hash = hashString "sha256" serviceName;
  vsockNumber = mod (builtins.fromTOML "n = 0x${substring 0 8 hash}").n 4096;
  mediaMounts = map (x: x.mountPoint) (filter (y: (hasPrefix "/media" y.mountPoint && y.readOnly == false)) config.microvm.shares);

  mod = a: b: a - (b * (a / b));
  macDigit = pos: substring pos 2 hash;
  ipDigit = pos: mod (builtins.fromTOML "n = 0x${substring 0 pos hash}").n 256;
  systemdMountName = path: "${concatStringsSep "-" (tail (splitString "/" path))}.mount";
in {
  microvm = {
    hypervisor = "cloud-hypervisor";

    interfaces = [
      {
        type = "tap";
        id = "vm-${serviceName}";
        mac = "02:00:00:${macDigit 1}:${macDigit 3}:${macDigit 5}";
      }
    ];

    mem = 1024;

    shares = [
      {
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        readOnly = true;

        proto = "virtiofs";
      }
    ];

    vcpu = 1;

    volumes = [
      {
        image = "data-${serviceName}.img";
        mountPoint = "/var/lib";
        size = 8192;
      }
    ];

    vsock = {
      cid = vsockNumber;
      ssh.enable = true;
    };
  };

  networking = {
    defaultGateway = {
      address = "10.0.${toString (ipDigit 3)}.1";
      interface = "ens3";
    };

    firewall.enable = true;

    hostName = "vm-${serviceName}";

    interfaces."ens3".ipv4.addresses = [
      {
        address = "10.0.${toString (ipDigit 3)}.2";
        prefixLength = 30;
      }
    ];
  };

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAcXQtfp/MZUibmmXM5xZGHEhLDUGCSKu0+fH9Mh3+Qa leo@odino"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1B/uxIDrKCh5PuJbJN92Dzs8zZjSywJ4LoSZZtFViS leo@thor"
  ];

  programs.htop.enable = true;

  services = {
    getty.autologinUser = "root";
    openssh.openFirewall = mkForce false;
  };

  systemd.services."fs-fix-${serviceName}" = mkIf ((length mediaMounts) > 0) {
    wantedBy = [ "multi-user.target" ];
    after = map systemdMountName mediaMounts;
    requires = map systemdMountName mediaMounts;

    serviceConfig = {
      Type = "oneshot";
      ExecStart = concatStringsSep "\n" (map (x: "${pkgs.coreutils}/bin/chmod 755 ${x}") mediaMounts);
    };
  };

  system.stateVersion = "26.05";
}
