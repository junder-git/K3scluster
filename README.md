# kubernetes
My local cluster for home-assistant, falcon40B-((GPU-enabled-ai)) and other dockerized apps...   
===  
1) https://nixos.wiki/wiki/NixOS_on_ARM  
2) https://nixos.wiki/wiki/Kubernetes
3) https://www.jeffgeerling.com/blog/2022/external-graphics-cards-work-on-raspberry-pi

===  
## Installation plan  
Nixos anywhere probs wont work in my case so...  I have sd and usb in the pi will jmux connect into all 4 and boot into the sd, format the usb across all simultaneously => . Add the correct partitioning, perhaps 32GB ==> "512MiB vfat @ /boot((/efi)) -Flag EF00", "5GB zfs @ /", "20GB zfs @ /var/lib/docker" "3GB zfs @ /var/log".    
  
(("10Gb zfs at /var/lib/rancher"->on-master))  
  
((While RAID 0 can offer significant performance benefits, it's important to be aware of its lack of data redundancy. Due to this inherent risk, RAID 0 is typically used in scenarios where speed and capacity are more critical than data protection.))  
  
((On a Raspberry Pi, you can achieve a similar outcome to RAID 0 by using ZFS with a striped configuration. ZFS supports striping, which spreads data across multiple drives for increased performance, much like RAID 0.))  
