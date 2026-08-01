{lib, pkgs, ...}:

let
  values = import ../../../vpn/values.nix {};
  website = pkgs.callPackage ../../../website {};

  publicDomain = values.publicDomain;
  privateDomain = values.privateDomain;
  vpn = lib.head (lib.filter
    ({ primary ? false, ... }: primary)
    lib.attrValues values.networks);

  makePublicHost = root: withAutoindex: {
    inherit root;

    useACMEHost = "${publicDomain}";
    addSSL = true;

    extraConfig = if withAutoindex then ''
      autoindex on;
    '' else "";
  };

  makePrivateHost = id: port: isPrivate: {
    locations."/".proxyPass = "http://${vpn.prefix}.${toString id}:${toString port}";

    extraConfig = if isPrivate then ''
      allow ${vpn.prefix}.0/24;
      deny all;
    '' else "";
  };
in {
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      # Public
      "${publicDomain}" = makePublicHost website false;
      "files.${publicDomain}" = makePublicHost "/srv/files" true;

      # Private
      "music.${privateDomain}" = makePrivateHost 2 9001 false;
      "images.${privateDomain}" = makePrivateHost 2 9002 true;
      "papers.${privateDomain}" = makePrivateHost 2 9003 true;
      "cinema.${privateDomain}" = makePrivateHost 2 9004 false;
      "torrent.${privateDomain}" = makePrivateHost 2 9005 true;
    };
  };
}
