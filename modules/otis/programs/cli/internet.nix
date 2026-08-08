{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    curl
    wget
    dig
    openssh
    rsync
    wireguard-tools
  ];
}
