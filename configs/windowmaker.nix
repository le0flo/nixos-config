{pkgs, ...}:

let
  gnustepDir = "GNUstep/Defaults";
  
  copyText = text: {
    inherit text;

    type = "copy";
    permissions = "644";
  };
in {
  files = {
    "${gnustepDir}/WMStart.sh" = copyText (builtins.readFile ./windowmaker/WMStart.sh);

    "${gnustepDir}/WMRootMenu" = copyText
      (builtins.replaceStrings
        [ "*windowmaker*" ]
        [ "${pkgs.windowmaker}" ]
        (builtins.readFile ./windowmaker/WMRootMenu));

    "${gnustepDir}/WindowMaker" = copyText
      (builtins.replaceStrings
        [ "*windowmaker*" ]
        [ "${pkgs.windowmaker}" ]
        (builtins.readFile ./windowmaker/WindowMaker));
  };
}
