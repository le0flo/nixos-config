{
  vmConfig = {
    fs.shares = [
      {
        mountName = "navidrome-music";
        guestDir = "/app/navidrome/music";
      }
      {
        mountName = "jellyfin-movies";
        guestDir = "/app/jellyfin/movies";
      }
      {
        mountName = "jellyfin-shows";
        guestDir = "/app/jellyfin/shows";
      }
    ];

    net = {
      address = "10.67.1.3";
      prefixLength = 16;

      gateway = {
        address = "10.67.0.1";
        prefixLength = 16;
      };

      allowedTCPPorts = [
        11001
        11002
      ];
    };

    services = {
      jellyfin = {
        enable = true;
        port = 11002;
      };
      navidrome = {
        enable = true;
        port = 11001;
        musicDir = "/app/navidrome/music";
      };
    };

    users = {
      "navidrome".id = 1001;
      "jellyfin".id = 1002;
    };
    groups = {
      "navidrome".id = 1001;
      "jellyfin".id = 1002;
    };
  };
}
