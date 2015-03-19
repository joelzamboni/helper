#!/usr/bin/env bash

# initial notes on gluster
# reference https://www.digitalocean.com/community/tutorials/how-to-create-a-redundant-storage-pool-using-glusterfs-on-ubuntu-servers
# Running on containers
lxc.cgroup.devices.allow = c 10:229 rwm 
mknod /dev/fuse c 10 229  


sudo apt-get install glusterfs-server

gluster peer probe <host>
gluster peer status

