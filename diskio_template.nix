{ config, lib, pkgs, ... }:

{
  imports = [
    # Include the disko module
    <nixpkgs/nixos/modules/installer/disko/disko.nix>
  ];

  disko = {
    devices = {
      disk = {
        x = {
          type = "disk";
          device = "/dev/sdx";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "512MiB";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot/efi";
                };
              };
              root = {
                size = "5GB";
                content = {
                  type = "zfs";
                  pool = "zroot";
                  options = {
                    ashift = 12; # Adjust for your drive's sector size
                    compression = "lz4";
                    atime = "off";
                    primarycache = "all";
                    secondarycache = "all";
                    recordsize = "128K";
                    logbias = "throughput";
                    sync = "disabled";
                  };
                };
              };
              docker = {
                size = "20GB";
                content = {
                  type = "zfs";
                  pool = "docker";
                  options = {
                    # Add dataset-specific options here if needed
                  };
                };
              };
              log = {
                size = "3GB";
                content = {
                  type = "zfs";
                  pool = "log";
                  options = {
                    # Add dataset-specific options here if needed
                  };
                };
              };
            };
          };
        };
      };
    };

    zpool = {
      zroot = {
        type = "zpool";
        mode = "striped"; # Change this to "striped" for RAID 0
      };
    };
  };
}
