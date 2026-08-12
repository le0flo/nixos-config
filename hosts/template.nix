{hostName, ...}:

{
  console.keyMap = "it";

  environment.shellAliases = {
    "host-build" = "sudo nixos-rebuild build --flake ~/nixos#host-${hostName}";
    "host-boot" = "sudo nixos-rebuild boot --flake ~/nixos#host-${hostName}";
    "host-switch" = "sudo nixos-rebuild switch --flake ~/nixos#host-${hostName}";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "it_IT.UTF-8";
      LC_IDENTIFICATION = "it_IT.UTF-8";
      LC_MEASUREMENT = "it_IT.UTF-8";
      LC_MONETARY = "it_IT.UTF-8";
      LC_NAME = "it_IT.UTF-8";
      LC_NUMERIC = "it_IT.UTF-8";
      LC_PAPER = "it_IT.UTF-8";
      LC_TELEPHONE = "it_IT.UTF-8";
      LC_TIME = "it_IT.UTF-8";
    };
  };

  networking = {
    hostName = "hermes";
    useDHCP = lib.mkDefault true;

    resolvconf.enable = true;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];

    firewall.enable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/Rome";
  
  users.users."root".initialHashedPassword = null;

  system.stateVersion = "26.05";
}
