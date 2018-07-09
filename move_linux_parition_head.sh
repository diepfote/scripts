#!/bin/bash
#
# taken from -> https://gist.github.com/phillipberndt/907560
#
# This script moves a disk's partition. This is useful if you
# want to resize two parititions, making the first one smaller and the second one bigger.
#
# Note that if your partitions are not encrypted, there are GUI tools to
# acomplish this (Gnome's GParted) and if you are using LVM you don't need this
# at all because there is no problem having fragmented partitions with LVM.
# If you can avoid using this script, do it! Using a GUI tool for such delicate stuff
# helps you avoid headaches ;-)
#
# Follow the instructions here EXACTLY or you WILL face data loss! Don't use this script
# if you do not understand either what I am telling you to do or why I do so!
#
# 1) Run fdisk -l on the disk you want to resize. Output should be something like
#
#    Disk /dev/sdb: 250.1 GB, 250059350016 bytes
#    255 heads, 63 sectors/track, 30401 cylinders
#    Units = cylinders of 16065 * 512 = 8225280 bytes
#    Sector size (logical/physical): 512 bytes / 512 bytes
#    I/O size (minimum/optimal): 512 bytes / 512 bytes
#    Disk identifier: 0x00000000
#    
#       Device Boot      Start         End      Blocks   Id  System
#    /dev/sdb1               1        3265    26226081   83  Linux
#    /dev/sdb2            3500       30401   217969920   83  Linux
#
#    In my setup, the first partition contains the root file system (ext4), while
#    the second is a dm-crypt'ed partition for /home, again containing an ext4
#    file system
#
# 2) Use the tool of your choice to shrink the first file system. For ext-filesystems
#    that's resize2fs. For example:
#     fsck -f /dev/sdb1
#     resize2fs /dev/sdb1 25G
#    The tool will complain if the size you enter is too small.
#
# 3) If the tool you used did not also shrink the partition (gparted can do that)
#    you have to do that yourself. Again using fdisk first delete the first
#    partition (press "d"), then create a new one (press "n") with the same
#    size you used in (2). Caution: You'll have to enter exactly the value for
#    "Start" you got in (1). In my case, it's 1 (which means the partition
#    starts on the first cylinder). Afterwards, if necessary, change the
#    partition type (press "t") to the old value and save using "w".
#
# 4) Run fsck on the file system, just to be sure. If it reports any errors, revert
#    the partition and check what you did wrong!
#
# 5) Now comes the point where you will have to use this script. Update the configuration
#    according to my instructions:

###########################################

# Enter the name of the disk (NOT the partition) you want to copy from and to
disk=sdb

# Enter the number from (1) from the line which says "Units = .. = xxx bytes"
UNIT=8225280

# Enter the new value of "End" of the first partition after you did step (3).
# In my case, that's 3265. The partition will be copied here. (Yes, enter the
# value of End. Do not add 1!)
PASTE_SKIP=3265

# Enter the "Start" value of the second partition minus one. In my case that's
# 3499. Note that this script copies in-place so this should be at least 10
# bigger than the value of $PASTE_SKIP (because we copy 10 sectors at once,
# more to that later)
COPY_SKIP=3499

# Enter the size of the partition to copy, plus one. In my case the length is
# "End" - "Start" = 26901, so I enter 26902
CYLINDER_COUNT=26902

###########################################

#    The script will, once you execute it, copy 10 sectors a time, check the
#    last two of them for errors (yes, I'm paranoid) and then write the status
#    to ./COPY_STATUS and sync(). That way, if your computer crashes during the
#    process, you can safely resume after a reboot (simply reexecute the script).
#
#    Note that the script will necessarily at some point start to overwrite the
#    old partition's data. So there is a point of no return, from which on you can't
#    simply abort the script. This point is reached when $COPY_SKIP - $PASTE_SKIP
#    cylinders have been copied.
#
#    The script will report on it's progress. It takes some time, relax. There's nothing
#    you can do now :-) If you are paranoid, abort the script after a minute or so -
#    all your old partition's data should still be intact - and create a new partition
#    in fdisk, which starts at $PASTE_SKIP + 1 and has arbitrary size. Run
#      dd if=/dev/sdb3 bs=100 count=1 | md5sum -
#      dd if=/dev/sdb2 bs=100 count=1 | md5sum -
#    and compare. Both values should be the same. Replace sdb3 by whatever you
#    named the new partition. You can safely remove the partition afterwards and
#    continue to run the script. But there is generally no need to take this step.
#    Again, if the two values don't match, abort!
#
# 6) As in step (3), start fdisk and this time remove your second partition. Recreate it
#    but enter $PASTE_SKIP + 1 as the "start" cylinder. Make it's size as big as you
#    want, but at least as big as the partition was before.
#
# 7) If the partion was, as in my case dm-crypt'ed, you don't have to care about resizing
#    the container. The crypto mapper recognizes the changed size automatically, nothing to
#    do here. Run cryptsetup and create the mapped device.
#
# 8) Either on your partition or on /dev/mapper/whatever run your resizing tool. It should
#    recognize the new partition size and fit the filesystem automatically. You should also
#    run fsck to check for possible errors.
#
#      fsck -f /dev/sdb2
#      resize2fs /dev/sdb2
#   
# 9) Mount it, enjoy it!
#

if ! [ -e COPY_STATUS ]; then
	echo 0 > COPY_STATUS
	echo "Info: Restarting copying"
	echo "WARNING!!!! DO NOT DO THIS AFTER THE STATUS EXCEEDED"
	echo "COPY_SKIP - PASTE_SKIP"
	read FOO
fi
COPY_STATUS=$(<COPY_STATUS)

copy_cylinder() {
	if ! dd if=/dev/$DISK of=/dev/$DISK ibs=$UNIT obs=$UNIT status=noxfer seek=$[$PASTE_SKIP + $1] skip=$[$COPY_SKIP + $1] count=1 2>/dev/null; then
		echo "Warning: Failed to copy sector $1"
		exit 1
	fi
}

check_2_cylinders() {
	MD5_SOURCE=$(dd if=/dev/$DISK ibs=$UNIT count=2 status=noxfer skip=$[$COPY_SKIP + $1] 2>/dev/null | md5sum - | awk '{print $1}')
	MD5_TARGET=$(dd if=/dev/$DISK ibs=$UNIT count=2 status=noxfer skip=$[$PASTE_SKIP + $1] 2>/dev/null | md5sum - | awk '{print $1}')

	if [ "$MD5_SOURCE" != "$MD5_TARGET" ]; then
		echo "Warning: At sector $1:"
		echo "Md5 at source: $MD5_SOURCE,"
		echo "Md5 at target: $MD5_TARGET"
		exit 1
	fi
}

status() {
	echo -ne "\r$COPY_STATUS of $CYLINDER_COUNT ("$[ $COPY_STATUS * 100 / $CYLINDER_COUNT ]"%)"
}

status
while true; do
	for i in 1 2 3 4 5 6 7 8 9 10; do
		copy_cylinder $COPY_STATUS
		COPY_STATUS=$[$COPY_STATUS + 1]
		if [ "$COPY_STATUS" == "$CYLINDER_COUNT" ]; then
			break
		fi
	done

	check_2_cylinders $[$COPY_STATUS - 2]
	echo $COPY_STATUS > COPY_STATUS
	sync
	status

	if [ "$COPY_STATUS" == "$CYLINDER_COUNT" ]; then
		break
	fi
done
