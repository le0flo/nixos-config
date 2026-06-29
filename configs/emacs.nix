{lib, pkgs, ...}:

let
  configFiles = builtins.filter
    (x: lib.hasSuffix ".el" x)
    (builtins.attrNames (builtins.readDir ./emacs));

  includeConfigs = lib.join
    "\n"
    (builtins.map
      (x: "(load-file \"~/.config/emacs/${x}\")")
      configFiles);

  packageConfigs = lib.genAttrs
    configFiles
    (file: {
      source = ./emacs/${file};
      target = "emacs/${file}";
      type = "copy";
      permissions = "644";
    });

  copyText = text: {
    inherit text;
    type = "copy";
    permissions = "664";
  };
in {
  xdg.config.files = {
    "emacs/init.el" = copyText ''
      ;; Includes
      ${includeConfigs}

      ;; Custom file
      (setq custom-file "~/.config/emacs/custom.el")
      (load-file custom-file)
    '';

    "emacs/custom.el" = copyText "";
  }
  // packageConfigs;
}
