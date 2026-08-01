{lib, modulesPath, ...}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
