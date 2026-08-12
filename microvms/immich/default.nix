{microvm, lib, ...}:

{
  microvm = {
    mem = lib.mkForce 4096;
    
    shares = [];

    forwardPorts = [
      {
        from = "host";
        host.port = 9002;
        guest.port = 9002;
      }
    ];
  };

  services.immich = {
    enable = true;

    host = "0.0.0.0";
    port = 9002;
    openFirewall = true;

    machine-learning.enable = false;
  };

  users.users."immich".extraGroups = [
    "render"
    "video"
  ];
}
