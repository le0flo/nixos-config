{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    dig
    curl
    git

    wireguard-tools
    openssl
    openssh
    rsync
  ];
}
