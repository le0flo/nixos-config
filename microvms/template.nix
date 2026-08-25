{microvm, serviceName, ...}:

{
  microvm = {
    hypervisor = "qemu";

    vcpu = 1;
    mem = 1024;

    shares = [
      {
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        readOnly = true;
      }
    ];

    interfaces = [
      {
        type = "user";
        id = "vm-${serviceName}";
        mac = "02:00:00:00:00:01";
      }
    ];    
  };

  networking = {
    hostName = "vm-${serviceName}";
    firewall.enable = true;
  };

  users.users."debug" = {
    createHome = true;

    extraGroups = [
      "render"
      "video"
      "wheel"
    ];

    initialPassword = "debug";
    isNormalUser = true;
  };

  programs.htop.enable = true;
  
  services.getty.autologinUser = "debug";

  system.stateVersion = "26.05";
}
