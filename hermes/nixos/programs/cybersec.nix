{lib, config, pkgs, ...}: {
  options.cybersec.enable = lib.mkEnableOption "cybersecurity tooling";

  config = lib.mkIf config.cybersec.enable {
    # Packages
    environment.systemPackages = with pkgs; [
      ascii file binwalk
      python313 pwntools
      gnat15 gdb gef gf
      dig
    ];
  };
}
