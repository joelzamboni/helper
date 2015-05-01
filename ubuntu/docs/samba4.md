# Install Samba4


## Pre Flight

* Install all updates
* Configure the ```/etc/hostname``` and ```/etc/hosts``` 
* Make the IP configuration static
* Enable time synchronization - NTP


### Configuring File System Permissions

Install ACL
```
sudo apt-get install acl
```
Change ```/etc/fstab``` from:
```
LABEL=FILESYTEM_LABEL   /        ext4   defaults        0 0
```
To:
```
LABEL=FILESYTEM_LABEL  / ext4 user_xattr,acl,barrier=1,errors=remount-ro,relatime 0 1
```
Run:
```
sudo mount -a
```

Install Samba Packages
```
sudo apt-get install samba krb5-user smbclient
```


 net ads keytab add nfs -U Administrator

References:

http://grokbase.com/t/centos/centos/1365qnen7k/samba4-and-nvsv4

https://access.redhat.com/discussions/497493
net ads join -U someuser%password



