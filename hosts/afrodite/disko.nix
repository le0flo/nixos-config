{disko, ...}:

{
  disko.devices.disk."main" = {
    device = "/dev/sda";
    type = "disk";
    
    content = {
      type = "gpt";

      partitions = {
        MBR = {
          type = "EF02";
          size = "1M";
          priority = 1;
        };
        
        ESP = {
          type = "EF00";
          size = 1G;

          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        swap = {
          size = "4G";

          content = {
            type = "swap";
            discardPolicy = "both";
            resumeDevice = true;
          };
        };
        
        root = {
          size = "100%";

          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
