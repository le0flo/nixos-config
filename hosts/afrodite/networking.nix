{config, inputs, lib, ...}:

let
  secretsPath = toString inputs.nixos-secrets;

  readKey = path: lib.trim (builtins.readFile path);
  makeNetwork = import ../../vpn/server.nix { inherit config inputs lib; };

  homeNetwork = makeNetwork "home" [
    { publicKey = readKey "${secretsPath}/wireguard/odino.pub"; id = 2; } # odino
    { publicKey = readKey "${secretsPath}/wireguard/thor.pub"; id = 3; } # thor
    { publicKey = readKey "${secretsPath}/wireguard/hermes.pub"; id = 101; } # hermes
    { publicKey = "cR1TRWLX8DqZtOEOR7djqlX0ewy648h8oHaZkW9JUjU="; id = 102; } # zeus
    { publicKey = "vdQbZ0/xbQnGlyPRFEC4gugOXaVPyF6n0vHVAlyLFjU="; id = 103; } # ares
  ];

  externalNetwork = makeNetwork "external" [
    { publicKey = "RD/w5EMw16BFWTbbsG2XIoXvPAxubDVmOjbzjWK2XF4="; id = 2; } # firetv
    { publicKey = "4o9ANbaAHabP1vJ2jaHLCePaFmELpyEX2ymkX6nJ/S0="; id = 3; } # mybaby
  ];
in {
  networking = lib.mkMerge [
    homeNetwork
    externalNetwork
    {
      hostName = "afrodite";
      useDHCP = lib.mkDefault true;

      nameservers = [
        "127.0.0.1"
        "208.67.222.222"
        "208.67.220.220"
      ];

      firewall.enable = true;
    }
  ];
}
