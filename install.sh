#! /bin/bash

if [ ! -d "/home/debian" ]; then

echo "APP_USER=debian" > /etc/profile.d/app_user.sh

. /etc/profile.d/app_user.sh

`useradd -m -p $(openssl passwd -1 password) $APP_USER -s /bin/bash`

echo "$APP_USER ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

cat >>/home/$APP_USER/.bashrc <<EOL
        `curl --silent https://gist.githubusercontent.com/ngonzalez/f418a775613e53a0b2f6d7dfd5d32429/raw/bashrc`
EOL

fi
