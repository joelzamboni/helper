#!/usr/bin/env bash

# intial notes on gluster

# Running on containers
lxc.cgroup.devices.allow = c 10:229 rwm 
mknod /dev/fuse c 10 229  
