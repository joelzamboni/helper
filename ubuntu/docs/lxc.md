



## Create LXC with LVM based backend 


```
lxc-create -n <container-name> -t ubuntu -B lvm --lvname test --vgname <vg_name> --fstype ext4 --fssize <size>GB
```
