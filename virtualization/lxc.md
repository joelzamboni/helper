



## Create LXC with LVM based backend 


```
lxc-create -n <container-name> -t ubuntu -B lvm --lvname test --vgname <vg_name> --fstype ext4 --fssize <size>GB
```


References

http://www.justinjudd.org/blog/2012/09/cloning-lxc-lvm-containers.html

https://www.thomas-krenn.com/en/wiki/HA_Cluster_with_Linux_Containers_based_on_Heartbeat,_Pacemaker,_DRBD_and_LXC

