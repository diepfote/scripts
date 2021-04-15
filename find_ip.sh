#!/usr/bin/env bash

quit_on_found=0
packet_count=2
subnet=""
verbose="-q"
interface='wlp4s0'

usage()
{
cat << EOF
find_ip 1.0 Robin Wood (dninja@gmail.com) (www.digininja.org)

Find used and unused IPs on a network you don't haven an IP address on

usage: $0 options

OPTIONS:
	-h                Show this message
	-c <packet count> The number of ping packets to send, default 2
	-s <subnet>       First 3 parts of the subnet to test, default 192.168.0
	-q                Quit when found first free address, default keep going
	-v                Verbose
  -i <interface>

EOF
}

have_arping=`which arping`

if [[ "$have_arping" == "" ]]
then
cat << EOF
usage: $0 options

You must have arping installed and in the current path for this scanner to work
EOF
	exit 1
fi

while getopts  ":hvs:qc:i:" flag
do
	case $flag in
		h)
			usage
			exit 1
			;;
		c)
			packet_count=$OPTARG
			;;
		q)
			quit_on_found=1
			;;
		s)
			subnet=$OPTARG
			;;
		v)
			verbose=""
			;;
    i)
      interface=$OPTARG
      ;;
		?)
			usage
			exit 1
			;;
	esac
done

if [[ "$subnet" == "" ]]
then
cat << EOF
usage: $0 options

You must provide a subnet
EOF
	exit 1
fi

if [[ "$verbose" == "" ]]
then
	if [[ $quit_on_found == 1 ]]
	then
		echo "Quiting when found a free address"
	fi
	echo "Testing subnet $subnet.0/24"
	echo "Sending $packet_count packets per IP"
fi

for i in {1..254}
#for i in {1..254}
do
	IP=$subnet.$i
	arping -I $interface $verbose -c $packet_count $IP
	result=$?
	if [[ $result == 0 ]]
	then
		echo "$IP Used"
	else
		echo "$IP Free"
		if [[ $quit_on_found == 1 ]]
		then
			exit
		fi
	fi
done
