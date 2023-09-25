# Define the target for the NixOS installation
{ config, lib, ... }:

{
  # Set the hostname of your Raspberry Pi
  networking.hostName = "my-pi";

  # Specify the boot device (SD card)
  boot.loader.grub.device = "/dev/mmcblk0";

  # Define the partitions on the SD card
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda2"; # Adjust this according to your setup
      preLVM = true;
    }
  ];

  # Create a ZFS pool on the USB drive
  storage.zfs.poolNames = [ "mypool" ];
  storage.zfs.autoScrub = true; # Enable automatic ZFS scrubbing

  # Define datasets on the ZFS pool
  storage.zfs.datasets = {
    root = {
      quota = "5G"; # Adjust the size as needed
      mountpoint = "/"; # Root filesystem
    };
    varlibdocker = {
      quota = "20G"; # Adjust the size as needed
      mountpoint = "/var/lib/docker";
    };
    varlog = {
      quota = "3G"; # Adjust the size as needed
      mountpoint = "/var/log";
    };
  };

  # Set up RAID (mirror) for /var/lib/rancher (if possible)
  storage.mdadm.devices = [
    { 
      name = "my-raid";
      devices = [ "/dev/sda3", "/dev/sdb3" ]; # Adjust device paths
      raidLevel = "1"; # RAID 1 (mirror)
    }
  ];

  # Define the file systems for /boot and /var/lib/rancher
  fileSystems."/boot" = {
    device = "/dev/mmcblk0p1"; # Adjust this according to your setup
    fsType = "ext4";
  };
  fileSystems."/var/lib/rancher" = {
    device = "/dev/md0"; # Use the RAID device
    fsType = "ext4"; # Adjust as needed
  };

  # Set up the network configuration
  networking.interfaces.eth0.useDHCP = true; # Use DHCP for Ethernet

  # Additional configuration for Rancher (if needed)
  # Add your Rancher-specific settings here

  # Add any other necessary configuration options here
}
