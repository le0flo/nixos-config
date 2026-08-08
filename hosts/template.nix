{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  console.keyMap = "it";

  environment.shellAliases = {
    "host-build" = "";
    "host-boot" = "";
    "host-switch" = "";
    "k" = "~/.config/scripts/kubectl-wrapper.sh";
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

  time.timeZone = "Europe/Rome";
  
  users.users."root".initialHashedPassword = null;
}
