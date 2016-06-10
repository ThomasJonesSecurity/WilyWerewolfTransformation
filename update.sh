#!/bin/bash

# INITIAL UPDATE
# ------------------------------------
apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y

# PRE-SCRIPT CHECKS
# ------------------------------------
# Free Disk Space > 10GB
df . | awk 'NR==2{if($4<=10*1024*1024) print "Available space < 10 GB\a"}'


# SOURCES & KEYS FOR 3RD PARTY APPS
# ------------------------------------

# Chrome 64-bit
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

# Spotify
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

# ANNOYANCES CORRECTED
# ------------------------------------
# Disable “System program problem detected” windows
sudo sed -i 's/^enabled=1/enabled=0/' /etc/default/apport


# HARDENING
# ------------------------------------
echo "[*]remote logon"
sh -c 'printf "[SeatDefaults]\ngreeter-show-remote-login=false\n" >/usr/share/lightdm/lightdm.conf.d/50-no-remote-login.conf'
echo "[*]guest user"
sh -c 'printf "[SeatDefaults]\nallow-guest=false\n" >/usr/share/lightdm/lightdm.conf.d/50-no-guest.conf'
echo "[*]restrict dmesg logs"
echo kernel.dmesg_restrict = 1 >> /etc/sysctl.conf
