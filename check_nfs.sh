#!/bin/sh


# get unique list of used nfs servers from /etc/fstab
nfs_server=$(grep nfs /etc/fstab |grep "^[^#;]"|awk  '{print $1}'|cut -d \: -f 1|sort -u)


# check mount points for each nfs server
# get list of mounts for each nfs server defined in fstab
for i in $nfs_server; do
   echo $i
   mount_folders=$(grep $i /etc/fstab |grep "^[^#;]"|awk  '{print $2}')
   echo $mount_folders
   #test if nfs serice exists on each nfs server
   rpcinfo -t $i nfs > /dev/null 2>&1
   exit_status=$?
   echo "Exit status for checking of nfs service on $i is $exit_status"
   for j in $mount_folders; do
        if [ $exit_status -eq 1 ]; then
                echo "NFS mount stale. Removing..."
                # gracefuly umount stale mountpoints
                umount -f -l $j 
        else
                fs=$(df -P -T $j | tail -n +2 | awk '{print $2}')
                echo "Filesystem on $j is $fs"
                if [ "$fs" == "nfs" ]; then
                        echo do nothing, nfs share is mounted and working fine...
                elif [ "$fs" == "xfs" ]; then
                        echo "NFS server is working but export not mounted"
                        echo "mounting" $j
                        mount $j
                else
                        echo "don't know what to do"
                fi
        fi
   done
done
