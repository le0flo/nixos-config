{pkgs, ...}:

{
  boot.supportedFilesystems = [
    "exfat"
    "ntfs"
  ];

  environment.systemPackages = with pkgs; [
    exfat
    ntfs3g
    android-tools
  ];
}
