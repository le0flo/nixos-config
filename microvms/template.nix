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
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" ];
    initialPassword = "debug";
  };

  programs.htop.enable = true;
  
  services.getty.autologinUser = "debug";

  system.stateVersion = "26.05";
}
