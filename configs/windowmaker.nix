{pkgs, ...}:

let
  copyText = text: {
    inherit text;

    type = "copy";
    permissions = "644";
  };
in {
  files = {
    ".xinitrc" = copyText (builtins.readFile ./windowmaker/xinitrc.sh);

    "GNUstep/Defaults/WMRootMenu" = copyText
      (builtins.replaceStrings
        [ "*windowmaker*" ]
        [ "${pkgs.windowmaker}" ]
        (builtins.readFile ./windowmaker/WMRootMenu));
  };
}
