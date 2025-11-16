{lib, config, pkgs, ...}:
  let
    rizin = pkgs.rizin.withPlugins(ps: with ps; [ jsdec rz-ghidra sigdb ]);
    cutter = pkgs.cutter.withPlugins(ps: with ps; [ rz-ghidra ]);
  in {
  options.cybersec.enable = lib.mkEnableOption "cybersecurity tooling";

  config = lib.mkIf config.cybersec.enable {
    # Packages
    environment.systemPackages = with pkgs; [
      ascii file binwalk codeql pwntools
      gnat15 python313 gdb gef rizin
      ghidra-bin cutter
      dig wireshark-qt
      postman burpsuite
    ];

    # Wireshark
    programs.wireshark.enable = true;
    programs.wireshark.dumpcap.enable = true;
    users.extraGroups."wireshark".members = [ "leo" ];
  };
}
