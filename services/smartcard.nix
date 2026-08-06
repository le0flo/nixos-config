{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [ pcsc-tools ];
  
  services.pcscd.enable = true;

  programs.firefox.nativeMessagingHosts.packages = with pkgs; [ web-eid-app ];
}
