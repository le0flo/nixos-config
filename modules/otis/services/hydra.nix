{config, customLib, hostName, lib, pkgs, secretsEnc, ...}:

let
  inherit (builtins) concatStringsSep;

  inherit (config.otis.net.dns) domains;

  inherit (customLib.config) systems;

  inherit (customLib.opts)
    mkBoolOption
    mkEnumOption
    mkIntOption
    mkListSubOption
    mkStrOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.services.hydra;

  buildMachinesOpts.options = {
    arch = mkEnumOption systems "Arch of the builder host" "x86_64-linux";
    host = mkStrOption "Ip of the builder host" "127.0.0.1";
    keyFile = mkStrOption "The ssh key file for the builder host" "";
    jobs = mkIntOption "The max jobs for the builder host" 1;
  };
in {
  options.otis.services.hydra = {
    enable = mkBoolOption "Enable the hydra service" false;
    role = mkEnumOption [ "server" "builder" ] "Role of the host in the hydra cluster" "builder";
    buildMachines = mkListSubOption buildMachinesOpts "List of builder hosts" [];
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.role == "server") {
      services.hydra = {
        enable = true;
        useSubstitutes = true;

        hydraURL = "https://hydra.${domains.public}";
        listenHost = "127.0.0.1";
        port = 9000;
        notificationSender = "hydra@localhost";

        buildMachinesFiles = [
          (pkgs.writeText "hydra-machines" (concatStringsSep "\n" (map (x: "ssh-ng://builder@${x.host} ${x.arch} ${x.keyFile} ${toString x.jobs} 1 kvm,nixos-test - -") cfg.buildMachines)))
        ];
      };
    })
    (mkIf (cfg.role == "builder") {
      users.users."builder" = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [ "${secretsEnc}/hydra/${hostName}.pub" ];

        home = "/var/lib/builder";
        createHome = true;
      };
    })
  ]);
}
