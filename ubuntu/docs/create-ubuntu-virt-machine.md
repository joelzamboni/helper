
# Create virtual machine using command line


* Mount the ISO image
```
  $ mount -t iso9660 -o loop ubuntu-14.04-server-amd64.iso /mnt
```

* Execute installation
```
  $ virt-install --connect qemu:///system -n ubuntu1404-vm1 -s 10 -r 512 \
-f /var/lib/KVM_images/ubuntu1404-vm1.img --vcpus=1 --os-type linux \
--os-variant ubuntutrusty --nographics  --location /mnt  \
--extra-args='console=tty0 console=ttyS0,115200n8' --keymap en
```
