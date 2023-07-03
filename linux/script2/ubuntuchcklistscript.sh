#colors
export PS1='\e[0;34m\u@\h:\W$\e[m'
#INSTRUCTIONS
#go to settings and make sure to allow internet downloads and stuff from multiverse
#in updates section

#MAKE SURE TO UPDATE UBUNTU 




######################################

#install/updgrade linux, press yes on window if install wants to be installed
sudo apt-get update
sudo apt-get upgrade
#_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
#upgrade
sudo apt update
#_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
#firewall
sudo ufw status verbose

#enable firewall
sudo ufw enable

#_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
#upgrade policies (ex check for updates every 1 day)
#go to settings and make sure everything is daily and all

#_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
#backdoors

sudo apt-get install rkhunter
sudo gedit /var/log/rkhunter.log 
sudo netstat -antu -p #port scan
sudo ps -e #list processes

#unhide hidden processes
sudo apt-get install unhide
sudo unhide-posix proc

#check the logs
sudo gedit /var/log/dpkg.log
sudo gedit /var/log/daemon.log
sudo gedit /var/log/user.log

#check repo
grep ^ /etc/apt/sources.list
/etc/apt/sources.list.d/*

#stop backdoor attacks
iptables -A OUTPUT -o eth1 -j DROP
iptables -N LOGGING #build a new link named logging
iptables -A OUTPUT -j LOGGING #add the outgoing traffic
iptables -A LOGGING -j DROP #decline packets

#_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
#make sure to answer Y for the below prompt
sudo apt-get install clamav #IF THIS DOESN'T WORK MAKE SURE TO UPDATE 
#SETTINGS WITH ALLOWING DOWNLOADS FROM INTERNET AND ALL

#stop and start clamav
sudo freshclam 
sudo /etc/init.d/clamav-freshclam stop
sudo freshclam
sudo /etc/init.d/clamav-freshclam start


#listing the infected files
clamscan -i -r ~/

#remove the viruses
clamscan --remove=yes -i -r ~/
#_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

#updates for all apps
sudo apt update
sudo apt upgrade

#_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
#

