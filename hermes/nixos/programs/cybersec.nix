{lib, config, pkgs, ...}: {
  options.cybersec.enable = lib.mkEnableOption "cybersecurity tooling";

  config = lib.mkIf config.cybersec.enable {
    # Packages
    environment.systemPackages = with pkgs; [
      file ascii
      gnat15 gdb gef ghidra-bin
      dig wireshark-qt postman
    ];

    # Wireshark
    programs.wireshark.enable = true;
    programs.wireshark.dumpcap.enable = true;
    users.extraGroups."wireshark".members = [ "leo" ];
  };
}
