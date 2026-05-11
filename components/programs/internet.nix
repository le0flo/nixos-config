{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    dig
    iw

    wireguard-tools
    openssl
    openssh
    rsync
  ];
}
