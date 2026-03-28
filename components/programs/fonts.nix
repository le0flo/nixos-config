{lib, config, pkgs, ...}: {
  options.fonts.enable = lib.mkEnableOption "Additional fonts";

  config = lib.mkIf config.fonts.enable {
    environment.systemPackages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      nerd-fonts.iosevka-term
      nerd-fonts.jetbrains-mono

      corefonts
      vista-fonts
    ];
  };
}
