{
  sirah = {
    cpu = 2;
    memory = 4096;
    disk = 8192;

    shares = [
      {
        host.dir = "/mnt/storage/music";
        guest.dir = "/media/music";
        readOnly = true;
      }
      {
        host.dir = "/mnt/storage/movies";
        guest.dir = "/media/movies";
        readOnly = true;
      }
      {
        host.dir = "/mnt/storage/shows";
        guest.dir = "/media/shows";
        readOnly = true;
      }
    ];

    net.allowedTCPPorts = [
      11001
      11002
    ];

    services = {
      jellyfin = {
        enable = true;
        port = 11002;
      };
      navidrome = {
        enable = true;
        port = 11001;
        musicDir = "/media/music";
      };
    };
  };
}
