# Setup Automatic Security Patches and Reboot

```
sudo apt-get install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades
```

Make sure that the following lines are included in the file /etc/apt/apt.conf.d/50unattended-upgrades:

```
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "02:00";
```
