{config, pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };

  parseColor = color: builtins.substring 1 6 color;
in {
  xdg.config.files."swaylock/config" = {
    type = "copy";
    permissions = "644";

    text =  ''
      ignore-empty-password
      show-failed-attempts

      indicator-idle-visible
      indicator-radius=100

      line-uses-inside

      clock
      timestr=%H:%M:%S
      datestr=%d %B

      image=${config.xdg.data.directory}/backgrounds/default
      effect-blur=6x7
      color=${parseColor style.colors.background}

      inside-color=${parseColor style.colors.background}
      inside-clear-color=${parseColor style.colors.background}
      inside-caps-lock-color=${parseColor style.colors.background}
      inside-ver-color=${parseColor style.colors.background}
      inside-wrong-color=${parseColor style.colors.background}

      key-hl-color=${parseColor style.colors.primary}
      caps-lock-key-hl-color=${parseColor style.colors.primary}

      bs-hl-color=${parseColor style.colors.secondary}
      caps-lock-bs-hl-color=${parseColor style.colors.secondary}

      ring-color=${parseColor style.colors.background}
      ring-clear-color=${parseColor style.colors.background}
      ring-caps-lock-color=${parseColor style.colors.background}
      ring-ver-color=${parseColor style.colors.background}
      ring-wrong-color=${parseColor style.colors.background}

      separator-color=${parseColor style.colors.background}

      text-color=${parseColor style.colors.text}
      text-clear-color=${parseColor style.colors.text}
      text-caps-lock-color=${parseColor style.colors.text}
      text-ver-color=${parseColor style.colors.text}
      text-wrong-color=${parseColor style.colors.text}
    '';
  };
}
