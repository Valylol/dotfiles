#config
REMOTE_SHARE="//192.168.178.178/PlexMedia"
MOUNT_POINT="/mnt/nas"

#mnt
sudo mount -t cifs "//192.168.178.178/PlexMedia" "/mnt/nas" -o credentials=/etc/samba/plexmedia.creds,uid=$(id -u),gid=$(id -g)
#check
if [ $? -eq 0 ]; then
    echo "mounted successfully"
    cd "$MOUNT_POINT"
    ls "$MOUNT_POINT"
else
    echo "mount failed"
fi
