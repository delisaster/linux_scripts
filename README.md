# linux_scripts
### check_nfs.sh
Checks the status of nfs mount points on client and doeas certain action depending on the status of remote NFS service and local mountpoints. The idea is to mitigate problems emerging due to stale nfs mounts without restarting the system.

You can put the script in your crontab and it will check your nfs mountpoints every minute.

To Do: 
* Create a daemon so that checks can be done every few seconds
* Solve the problem with forced umount even when nfs share is not mounted
* Create a log file output
* check bind mounts and remout them after respective mounts become active
* comment and flag all non working mounts
* add email notification to for all new non working mounts

