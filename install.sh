#!/usr/bin/env bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit 1
fi

if [[ -z "$1" ]]; then
    echo "./install.sh <your_authtoken>"
    exit 1
fi

mkdir -p /opt/ngrok

cd /opt/ngrok
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip

if [[ -f ngrok-stable-linux-arm.zip ]]; then
    unzip ngrok-stable-linux-arm.zip
    rm -f ngrok-stable-linux-arm.zip
else
    echo "Unable to download ngrok..."
    exit 1
fi

curl -Lso /lib/systemd/system/ngrok.service https://github.com/screencom/systemd-ngrok/raw/master/ngrok.service
curl -Lso /opt/ngrok/ngrok.yml https://github.com/screencom/systemd-ngrok/raw/master/ngrok.yml
sed -i "s/<add_your_token_here>/$1/g" /opt/ngrok/ngrok.yml

systemctl enable ngrok.service
systemctl start ngrok.service
