{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    git
    gnumake
    mariadb
    postgresql
    sqlite
  ];
}
