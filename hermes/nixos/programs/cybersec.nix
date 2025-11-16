{lib, config, pkgs, ...}: {
  options.cybersec.enable = lib.mkEnableOption "cybersecurity tooling";

  config = lib.mkIf config.cybersec.enable {
    # Packages
    environment.systemPackages = with pkgs; [
      ascii file binwalk codeql pwntools
      gnat15 python313 gdb gef
      ghidra-bin cutter cutterPlugins.rz-ghidra
      dig wireshark-qt
      postman burpsuite
    ];

    # Wireshark
    programs.wireshark.enable = true;
    programs.wireshark.dumpcap.enable = true;
    users.extraGroups."wireshark".members = [ "leo" ];
  };
}
