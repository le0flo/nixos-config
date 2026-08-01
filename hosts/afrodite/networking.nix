{lib, ...}:

let
  makeNetwork = import ../../vpn/server.nix {};
in {
  networking = {
    hostName = "afrodite";
    useDHCP = lib.mkDefault true;

    nameservers = [
      "127.0.0.1"
      "208.67.222.222"
      "208.67.220.220"
    ];

    firewall.enable = true;
  }
  // makeNetwork "home" [
    { publicKey = "GX/1ks+T1OcBsW7XiMIN1k2/azaCWH69eGh9dltfJhU="; id = 2; } # odino
    { publicKey = "O0qmhfzHIvEQjnr8sttLfur7uZ7+u72BNoWEyo2pmX0="; id = 3; } # thor
    { publicKey = "99XBoIZ55yradB45bDZ94fc1IQGkNp9argWaT2otRBU="; id = 101; } # hermes
    { publicKey = "cR1TRWLX8DqZtOEOR7djqlX0ewy648h8oHaZkW9JUjU="; id = 102; } # zeus
    { publicKey = "vdQbZ0/xbQnGlyPRFEC4gugOXaVPyF6n0vHVAlyLFjU="; id = 103; } # ares
  ]
  // makeNetwork "external" [
    { publicKey = "RD/w5EMw16BFWTbbsG2XIoXvPAxubDVmOjbzjWK2XF4="; id = 2; } # firetv
    { publicKey = "4o9ANbaAHabP1vJ2jaHLCePaFmELpyEX2ymkX6nJ/S0="; id = 3; } # mybaby
  ];
}
