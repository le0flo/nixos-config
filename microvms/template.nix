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

  users.users."root".initialPassword = "root";

  programs.htop.enable = true;
  
  system.stateVersion = "26.05";
}
