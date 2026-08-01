{...}:

{
  publicDomain = "leoflo.me";
  privateDomain = "home.arpa";

  networks = {
    "home" = {
      primary = true;
      prefix = "10.69.0";
      port = 51820;
      privateKey = "/etc/wireguard/home";
      publicKey = "9EsDl0sK6V+Y/MKMlHFZ1qO6VZBWNkQUQKJZujT3bRg=";
    };

    "external" = {
      prefix = "10.96.0";
      port = 51821;
      privateKey = "/etc/wireguard/external";
      publicKey = "wI7HVkYMaGN4mZkrrV1OaNgnCL6k5tRfiyzkK0822iQ=";
    };
  };
}
