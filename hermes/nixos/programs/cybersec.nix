{lib, config, pkgs, ...}: {
  options.cybersec.enable = lib.mkEnableOption "cybersecurity tooling";

  config = lib.mkIf config.cybersec.enable {
    # Packages
    environment.systemPackages = with pkgs; [
      ascii file binwalk pwntools
      gnat15 python313 gdb gef gf
      dig wireshark-qt
    ];

    # Wireshark
    programs.wireshark.enable = true;
    programs.wireshark.dumpcap.enable = true;
    users.extraGroups."wireshark".members = [ "leo" ];
  };
}
