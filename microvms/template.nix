{microvm, pkgs, serviceName, ...}:

let
  inherit (builtins)
    hashString
    substring;

  hash = hashString "sha256" serviceName;

  mod = a: b: a - (b * (a / b));
  macDigit = pos: substring pos 2 hash;
  vsockNumber = mod (builtins.fromTOML "n = 0x${substring 0 8 hash}").n 4096;
in {
  microvm = {
    hypervisor = "qemu";

    interfaces = [
      {
        type = "user";
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

    vsock = {
      cid = vsockNumber;
      ssh.enable = true;
    };
  };

  networking = {
    hostName = "vm-${serviceName}";
    firewall.enable = true;
  };

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA2uZphRK1orNSM4hMSELHVWfL29W4EpA5F9UGxrY7Nk leo@odino"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1B/uxIDrKCh5PuJbJN92Dzs8zZjSywJ4LoSZZtFViS leo@thor"
  ];

  programs.htop.enable = true;

  services.getty.autologinUser = "root";

  system.stateVersion = "26.05";
}
