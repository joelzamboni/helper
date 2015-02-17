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


