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
                };
              };
              docker = {
                size = "20GB";
                content = {
                  type = "zfs";
                  pool = "docker";
                };
              };
              log = {
                size = "3GB";
                content = {
                  type = "zfs";
                  pool = "log";
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
        mode = "striped"; # Change this to "striped" from "mirrored" for RAID 0
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          docker = {
            type = "zfs_fs";
            mountpoint = "/var/lib/docker";
          };
          log = {
            type = "zfs_fs";
            mountpoint = "/var/log";
          };
        };
      };
    };
  };
}
