{config, customLib, lib, pkgs, ...}:

let
  inherit (config.services.qbittorrent) profileDir;

  inherit (customLib.opts)
    mkBoolOption
    mkPortOption
    mkStrOption;

  inherit (lib) mkAfter;

  cfg = config.sirah.services.qbittorrent;
in {
  options.sirah.services.qbittorrent = {
    enable = mkBoolOption "Enable the qBitTorrent web client" false;
    port = mkPortOption "Port of the qBitTorrent server" 12001;
    envDir = mkStrOption "Environment file directory" "/etc/qbittorrent";
    storageDir = mkStrOption "Directory of the qBitTorrent downloads" "/media/bt";
  };

  config = {
    services.qbittorrent = {
      inherit (cfg) enable;

      webuiPort = cfg.port;

      serverConfig = {
        LegalNotice.Accepted = true;
        Preferences = {
          Downloads = {
            SavePath = "${cfg.storageDir}/complete";
            TempPath = "${cfg.storageDir}/incomplete";
          };
          WebUI = {
            CSRFProtection = false;
            HostHeaderValidation = false;
            ReverseProxySupportEnabled = true;
          };
        };
      };
    };

    systemd.services."qbittorrent" =  let
      script = ''
      set -euo pipefail

      # Config folder
      config="${profileDir}/qBittorrent/config/qBittorrent.conf"

      mkdir -p "$(dirname "$config")"
      if [ -f "$config" ]; then
        sed -i '/^WebUI\\Password_PBKDF2=/d' "$config"
      fi

      # Password
      password="$(cat ${cfg.envDir}/password)"
      salt="$(${pkgs.openssl}/bin/openssl rand -base64 16)"
      hash="$(${pkgs.python3}/bin/python3 - "$password" "$salt" <<PY
      import sys
      import base64
      import hashlib

      password = sys.argv[1].encode()
      salt = base64.b64decode( sys.argv[2])
      derived = hashlib.pbkdf2_hmac( "sha512", password, salt, 100000 )

      print( base64.b64encode(salt).decode() + ":" + base64.b64encode(derived).decode() )
      PY)"

      cat >> "$config" <<EOF
      WebUI\Password_PBKDF2="@ByteArray($hash)"
      EOF
      '';
    in {
      serviceConfig.ExecStartPre = mkAfter [ "${pkgs.writeShellScript "qbittorrent-password" script}" ];
    };
  };
}
