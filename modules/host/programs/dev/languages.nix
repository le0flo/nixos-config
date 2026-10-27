{config, customLib, lib, pkgs, ...}:

let
  inherit (config.hostConfig.programs) dev;

  inherit (customLib.hjem) configText;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.hostConfig.programs.dev.languages;
in {
  options.hostConfig.programs.dev.languages.enable = mkBoolOption "Programming language related" false;

  config = mkIf (cfg.enable && dev.enable) {
    environment.systemPackages = with pkgs; [
      gnumake
      meson
      ninja
      pkg-config
      maven
      gradle
      ant
      cargo
    ] ++ [
      gcc
      jdk25
      python313
      nodejs
      rustc
      dart
      flutter
    ] ++ [
      tree-sitter
      nil
      nixd
      basedpyright
      ruff
      rust-analyzer
    ];

    hostConfig.hjem = [{
      files.".npmrc" = configText "prefix=~/.local/share/npm";
      xdg.config.files."env/npm.env" = configText "PATH=$HOME/.local/share/npm/bin:$PATH";
    }];
  };
}
