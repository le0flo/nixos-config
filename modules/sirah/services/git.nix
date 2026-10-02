{config, customLib, lib, pkgs, ...}:

let
  inherit (customLib.opts)
    mkBoolOption
    mkPortOption
    mkStrOption;

  inherit (lib) mkIf;

  cfg = config.sirah.services.git;
in {
  options.sirah.services.git = {
    enable = mkBoolOption "Enable the gitolite and cgit servers" false;
    webPort = mkPortOption "Port of the cgit server" 13001;
    sshPort = mkPortOption "Port of the gitolite server" 13022;
    projectsDir = mkStrOption "Directory of the project storage" "/media/projects";
    adminPubkey = mkStrOption "Gitolite admin ssh key" "";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.git ];

    services = {
      cgit."main" = {
        enable = true;
        user = "git";
        group = "git";

        gitHttpBackend = {
          enable = true;
          checkExportOkFiles = true;
        };
        nginx.virtualHost = "cgit";

        scanPath = "${cfg.projectsDir}/repositories";
        settings.strict-export = "git-daemon-export-ok";
      };

      gitolite = {
        inherit (cfg) adminPubkey;

        enable = true;
        user = "git";
        group = "git";

        dataDir = cfg.projectsDir;
        description = "Git";
      };

      nginx.virtualHosts."cgit" = {
        serverName = "_";
        listen = [{ addr = "0.0.0.0"; port = cfg.webPort; }];
      };

      openssh.ports = [
        22
        cfg.sshPort
      ];
    };
  };
}
