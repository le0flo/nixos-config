{config, lib, ...}: let
  hexToRgb = hex: let
    hexChars = {
      "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4;
      "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
      "a" = 10; "b" = 11; "c" = 12; "d" = 13; "e" = 14; "f" = 15;
    };
    h = c: hexChars.${lib.toLower c};
    r = (h (builtins.substring 0 1 hex)) * 16 + (h (builtins.substring 1 1 hex));
    g = (h (builtins.substring 2 1 hex)) * 16 + (h (builtins.substring 3 1 hex));
    b = (h (builtins.substring 4 1 hex)) * 16 + (h (builtins.substring 5 1 hex));
  in "${toString r},${toString g},${toString b}";

  c = config.lib.stylix.colors;
  rgb = name: hexToRgb "${c.${name}}";

  accent = rgb "base0D";
  bg0 = rgb "base00";
  bg1 = rgb "base01";
  bg2 = rgb "base02";
  fg0 = rgb "base05";
  fg1 = rgb "base04";
  red = rgb "base08";
  orange = rgb "base09";
  green = rgb "base0B";

  colorGroup = { bg ? bg0, bgAlt ? bg1 }: ''
    BackgroundAlternate=${bgAlt}
    BackgroundNormal=${bg}
    DecorationFocus=${accent}
    DecorationHover=${accent}
    ForegroundActive=${accent}
    ForegroundInactive=${fg1}
    ForegroundLink=${accent}
    ForegroundNegative=${red}
    ForegroundNeutral=${orange}
    ForegroundNormal=${fg0}
    ForegroundPositive=${green}
    ForegroundVisited=${fg1}'';
in {
  xdg.configFile."kdeglobals".text = ''
    [ColorEffects:Disabled]
    ChangeSelectionColor=
    Color=${bg2}
    ColorAmount=0
    ColorEffect=0
    ContrastAmount=0.65
    ContrastEffect=1
    Enable=
    IntensityAmount=0.1
    IntensityEffect=2

    [ColorEffects:Inactive]
    ChangeSelectionColor=true
    Color=${fg1}
    ColorAmount=0.025
    ColorEffect=2
    ContrastAmount=0.1
    ContrastEffect=2
    Enable=false
    IntensityAmount=0
    IntensityEffect=0

    [Colors:Button]
    ${colorGroup { bg = bg1; bgAlt = bg2; }}

    [Colors:Complementary]
    ${colorGroup {}}

    [Colors:Header]
    ${colorGroup { bg = bg1; bgAlt = bg0; }}

    [Colors:Header][Inactive]
    ${colorGroup { bg = bg0; bgAlt = bg1; }}

    [Colors:Selection]
    BackgroundAlternate=${accent}
    BackgroundNormal=${accent}
    DecorationFocus=${accent}
    DecorationHover=${accent}
    ForegroundActive=${accent}
    ForegroundInactive=255,255,255
    ForegroundLink=${accent}
    ForegroundNegative=${red}
    ForegroundNeutral=${orange}
    ForegroundNormal=255,255,255
    ForegroundPositive=${green}
    ForegroundVisited=${fg1}

    [Colors:Tooltip]
    ${colorGroup { bg = bg1; bgAlt = bg0; }}

    [Colors:View]
    ${colorGroup {}}

    [Colors:Window]
    ${colorGroup {}}

    [Icons]
    Theme=breeze-dark

    [General]
    AccentColor=${accent}
    LastUsedCustomAccentColor=${accent}

    [KDE]
    LookAndFeelPackage=org.kde.breezedark.desktop

    [WM]
    activeBackground=${bg1}
    activeBlend=${fg0}
    activeForeground=${fg0}
    inactiveBackground=${bg0}
    inactiveBlend=${fg1}
    inactiveForeground=${fg1}
  '';
}
