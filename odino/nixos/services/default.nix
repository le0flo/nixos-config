{...}: {
  # OpenSSH
  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      PrintMotd = false;
    };
  };

  # XMRig
  services.xmrig = {
    enable = true;

    settings = {
      autosave = true;
      cpu = true;
      opencl = false;
      cuda = false;
      pools = [
        {
          algo = "rx/0";
          url = "xmr-eu1.nanopool.org:10343";
          user = "89erpoKiHuXbw1e1t8UZjNT1AX1Y9z1pta3f6akwG8okZSaLvFQ1eCJ4ih3tSH4Q9BPqHua3vfn6w1ZjQ98TQQHx5GHaRqf";
          keepalive = true;
          tls = true;
        }
      ];
    };
  };
}
