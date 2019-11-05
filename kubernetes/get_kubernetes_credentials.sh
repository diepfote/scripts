#!/usr/bin/env bash

hostname="$1"
filename="$2"

if  [ -z "$3" ]; then
  admin_file_location=/etc/kubernetes/admin.conf
else
  mnt_point=/mnt/data/k3s/data/
  username="$(ssh $hostname -- 'echo $USER')"
  command_for_k3s_host="sudo find "$mnt_point" -name 'kubectl' -exec sh -c '"{}" config view --raw | sed 's#127.0.0.1#k3s01#g' > /home/"$username"/admin.conf' \;"
fi

case "$1" in
  --help | -h | '' )
    echo "Usage: $0  <host to get creds from>  <filename to copy contents to in ~/.kube>  [<boolean for is_k3s_host>]"
    ;;
  *)

    if [ -z "$command_for_k3s_host" ]; then
    # vanilla kubernetes
      ssh_input='sudo cp '"$admin_file_location"' /home/$USER/; sudo chown $USER:$USER /home/core/admin.conf'
      ssh "$hostname" -- "$ssh_input"
    else
    # vanilla k3s
      ssh "$hostname" -- "$command_for_k3s_host"
    fi


    scp "$hostname":'/home/*/admin.conf' ~/.kube/"$filename"

    ssh_input='sudo rm /home/*/admin.conf'
    ssh "$hostname" -- "$ssh_input"
    ;;
esac



