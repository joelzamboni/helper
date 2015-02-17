#!/usr/bin/env bash

set -x

lxc-stop -n $1
lxc-destroy -n $1
lxc-create -n $1 -t ubuntu
lxc-start -n $1 -d 
sleep 5
$(lxc-ls -f | grep RUNNING|grep $1|awk '{ print "ssh-copy-id ubuntu@" $3}') 

