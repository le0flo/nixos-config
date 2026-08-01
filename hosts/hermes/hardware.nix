{lib, inputs, modulesPath, ...}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l14-intel
  ];

  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = lib.mkDefault true;
    intel-gpu-tools.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
