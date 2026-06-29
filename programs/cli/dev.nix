{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    git
    postgresql
    sqlite
    freetds
  ];
}
