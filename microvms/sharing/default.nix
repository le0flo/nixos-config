{config, microvm, pkgs, ...}:

let
  btPort = 12001;
  btEnvDir = "/run/secrets/bt";
  btDownloadDir = "/media/bt";

  slskPort = 12002;
  slskEnvDir = "/run/secrets/slsk";
  slskDownloadDir = "/media/slsk";
in {
  microvm = {
    shares = [
      {
        tag = "bittorrent-secrets";
        source = "/etc/qbittorrent";
        mountPoint = btEnvDir;
        readOnly = true;

        proto = "virtiofs";
      }
      {
        tag = "bittorrent-downloads";
        source = "/mnt/storage/downloads/bt";
        mountPoint = btDownloadDir;

        proto = "virtiofs";
        posixAcl = false;
        extraArgs = [
          "--translate-uid" "map:998:1000:1"
          "--translate-gid" "map:998:100:1"
        ];
      }
      {
        tag = "soulseek-secrets";
        source = "/etc/slskd";
        mountPoint = slskEnvDir;
        readOnly = true;

        proto = "virtiofs";
      }
      {
        tag = "soulseek-downloads";
        source = "/mnt/storage/downloads/slsk";
        mountPoint = slskDownloadDir;

        proto = "virtiofs";
        posixAcl = false;
        extraArgs = [
          "--translate-uid" "map:997:1000:1"
          "--translate-gid" "map:997:100:1"
        ];
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [
    btPort
    slskPort
  ];

  services = {
    qbittorrent = {
      enable = true;

      webuiPort = btPort;
      serverConfig = {
        LegalNotice.Accepted = true;
        Preferences = {
          Downloads = {
            SavePath = "${btDownloadDir}/complete";
            TempPath = "${btDownloadDir}/incomplete";
          };
          WebUI = {
            CSRFProtection = false;
            HostHeaderValidation = false;
            ReverseProxySupportEnabled = true;
          };
        };
      };
    };

    slskd = {
      enable = true;

      environmentFile = "${slskEnvDir}/environment";
      settings = {
        directories = {
          downloads = "${slskDownloadDir}/complete";
          incomplete = "${slskDownloadDir}/incomplete";
        };
        web.port = slskPort;
      };
    };
  };

  systemd.services."qbittorrent-init" =  let
    inherit (config.services.qbittorrent) group user;
  in {
    wantedBy = [ "qbittorrent-nox.service" ];
    after = [ "qbittorrent-nox.service" ];

    serviceConfig = {
      Type = "oneshot";
      User = user;
      Group = group;
    };

    script = pkgs.writeShellScript "qbittorrent-write-password" ''
    set -euo pipefail

    # Config folder
    config="${config.services.qbittorrent.profileDir}/qBittorrent/config/qBittorrent.conf"

    mkdir -p "$(dirname "$config")"
    if [ -f "$config" ]; then
      sed -i '/^WebUI\\Password_PBKDF2=/d' "$config"
    fi

    # Password
    password="$(cat ${btEnvDir}/password)"
    salt="$(openssl rand -base64 16)"
    hash="$(${pkgs.python3}/bin/python3 - "$password" "$salt" <<PY
    import sys
    import base64
    import hashlib

    password = sys.argv[1].encode()
    salt = base64.b64decode( sys.argv[2])
    derived = hashlib.pbkdf2_hmac( "sha512", password, salt, 100000 )

    print( base64.b64encode(salt).decode() + ":" + base64.b64encode(derived).decode() )
    PY
    )"

    cat >> "$config" <<EOF
    WebUI\Password_PBKDF2="@ByteArray($hash)"
    EOF
    '';
  };
}
