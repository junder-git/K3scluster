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

((When setting up ZFS in a striped (RAID 0) configuration, you can configure certain options for your datasets to optimize performance and adjust behavior. Here are some ZFS dataset options that you might consider adding to the `zfs datasets` block in your NixOS configuration to aid the striped mode:

1. **ashift**:
   - `ashift` sets the block size alignment for the ZFS pool. For most modern drives, an `ashift` value of 12 (for 4K sector drives) is appropriate. It's essential to align the block size properly for optimal performance.

   ```nix
   ashift = 12;
   ```

2. **compression**:
   - You can enable compression to save space and potentially improve read and write performance, especially with SSDs. ZFS supports different compression algorithms like "lz4" or "zstd."

   ```nix
   compression = "lz4";
   ```

3. **atime**:
   - By default, ZFS records access times (atime) for files, which can lead to extra I/O operations. If you don't need access times, you can disable them to reduce I/O overhead.

   ```nix
   atime = "off";
   ```

4. **primarycache and secondarycache**:
   - These options control how ZFS caches data in memory. For datasets where you want to optimize read performance, you can set `primarycache` to "all" to cache both metadata and data in RAM. You can also set `secondarycache` to "all" to enable the use of the L2ARC cache if you have it.

   ```nix
   primarycache = "all";
   secondarycache = "all";
   ```

5. **recordsize**:
   - The `recordsize` option defines the record size for files in the dataset. For datasets with large files, increasing the record size can improve performance.

   ```nix
   recordsize = "128K";
   ```

6. **logbias**:
   - For datasets where synchronous writes are important, you can set the `logbias` option to "throughput" to prioritize write throughput over latency.

   ```nix
   logbias = "throughput";
   ```

7. **sync**:
   - The `sync` option controls whether writes are synchronous or asynchronous. For datasets where write performance is crucial, you can set `sync` to "disabled," but be aware that this increases the risk of data loss in case of system crashes.

   ```nix
   sync = "disabled";
   ```

Remember to evaluate your specific use case and storage workload when choosing these options. The optimal settings may vary depending on your Raspberry Pi's hardware and how you plan to use the storage.
))
