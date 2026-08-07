{config, inputs, lib, pkgs, ...}:

let
  values = import ../../../vpn/values.nix { inherit config inputs lib; };
  publicWebsite = pkgs.callPackage ../../../www/public { inherit config inputs lib; };
  privateWebsite = pkgs.callPackage ../../../www/private { inherit config inputs lib; };

  publicDomain = values.publicDomain;
  privateDomain = values.privateDomain;
  vpn = lib.head (builtins.filter
    ({ primary ? false, ... }: primary)
    (lib.attrValues values.networks));

  makePublicHost = root: withAutoindex: {
    inherit root;

    useACMEHost = "${publicDomain}";
    addSSL = true;

    extraConfig = if withAutoindex then ''
      autoindex on;
    '' else "";
  };
  
  makePrivateHost = root: withAutoindex: {
    inherit root;

    extraConfig = if withAutoindex then ''
      autoindex on;
    '' else "";
  };

  makePrivateProxyHost = id: port: isPrivate: {
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
      "${publicDomain}" = makePublicHost publicWebsite false;
      "files.${publicDomain}" = makePublicHost "/srv/files" true;

      # Private
      "${privateDomain}" = makePrivateHost privateWebsite false;
      "music.${privateDomain}" = makePrivateProxyHost 2 9001 false;
      "images.${privateDomain}" = makePrivateProxyHost 2 9002 true;
      "papers.${privateDomain}" = makePrivateProxyHost 2 9003 true;
      "cinema.${privateDomain}" = makePrivateProxyHost 2 9004 false;
      "torrent.${privateDomain}" = makePrivateProxyHost 2 9005 true;
    };
  };
}
