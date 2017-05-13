#sudo lvcreate -L 4GB -s -n s_home-$(date +%m-%d-%Y_%H.%M.%S) /dev/VolGroup00/home && sudo lvcreate -L 3GB -s -n s_root-$(date +%m-%d-%Y_%H.%M.%S) /dev/VolGroup00/root && sudo lvcreate -L 3GB -s -n s_var-$(date +%m-%d-%Y_%H.%M.%S) /dev/VolGroup00/var
sudo lvcreate -L 4GB -s -n s_home-$(date +%m-%d-%Y) /dev/VolGroup00/home && sudo lvcreate -L 3GB -s -n s_root-$(date +%m-%d-%Y) /dev/VolGroup00/root

