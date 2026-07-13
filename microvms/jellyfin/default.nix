{microvm, lib, ...}:

{
  _module.args.serviceName = "jellyfin";
  imports = [ ../template.nix ];
  
  microvm = {
    mem = lib.mkForce 4096;
    
    shares = [
      {
        tag = "movies";
        source = "/mnt/storage/movies";
        mountPoint = "/media/movies";
        readOnly = true;
      }
      {
        tag = "series";
        source = "/mnt/storage/series";
        mountPoint = "/media/series";
        readOnly = true;
      }
    ];

    forwardPorts = [
      {
        from = "host";
        host.port = 9004;
        guest.port = 8096;
      }
    ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
