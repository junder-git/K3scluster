# Import the NixOS modules we need
{ config, lib, ... }:

{
  # Define the partition sizes
  bootSize = "512MiB";
  rootSize = "5GB";
  dockerSize = "20GB";
  logSize = "3GB";

  # Define the partition mount points
  bootMount = "/boot";
  rootMount = "/";
  dockerMount = "/var/lib/docker";
  logMount = "/var/log";

  # Define the EFI system partition
  efiSystemPartition = {
    device = "/dev/disk/by-partlabel/efi";
    size = bootSize;
    fsType = "ext4";
  };

  # Define the root partition
  rootPartition = {
    device = "/dev/disk/by-partlabel/root";
    size = rootSize;
    fsType = "zfs";
  };

  # Define the Docker partition
  dockerPartition = {
    device = "/dev/disk/by-partlabel/docker";
    size = dockerSize;
    fsType = "zfs";
  };

  # Define the log partition
  logPartition = {
    device = "/dev/disk/by-partlabel/log";
    size = logSize;
    fsType = "zfs";
  };

  # Define the file systems for the partitions
  fileSystems = [
    efiSystemPartition
    rootPartition
    dockerPartition
    logPartition
  ];

  # Define the bootloader configuration
  boot.loader = {
    efiSupport = true;
    grub.enable = true;
    grub.efiInstallAsRemovable = true;
    grub.devices = [ "/dev/sda" ]; # Specify your EFI disk here
  };

  # Define the ZFS configuration
  boot.supportedFilesystems = [ "zfs" ];

  fileSystems."/".fsType = "zfs";
  fileSystems."/var/lib/docker".fsType = "zfs";
  fileSystems."/var/log".fsType = "zfs";

  services.openssh.enable = true; # Enable SSH access

  # Add any other system configurations as needed

  # Add the partitions to the configuration
  hardware = {
    partitioning = {
      scheme = "gpt";
      partitions = fileSystems;
    };
  };
}
