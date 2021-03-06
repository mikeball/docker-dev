#!/usr/bin/env sh
groupadd --gid $HOST_GID $HOST_USER
useradd $HOST_USER --home /home/$HOST_USER --gid $HOST_GID --uid $HOST_UID
echo "$HOST_USER:pw" | chpasswd


#setup lein for this user
cp -r /root/.lein /home/$HOST_USER/.lein


#make sure all permissions are good to go.
chown -R $HOST_USER:$HOST_USER /home/$HOST_USER

su $HOST_USER