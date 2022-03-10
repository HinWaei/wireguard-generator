#!/bin/bash

cd "/etc/wireguard/"
ls | grep -E ".*\.conf"
read -p "Please enter your server config name[mygame.conf]:" -e server

wg genkey | tee privKeyClient
cat privKeyClient | wg pubkey | tee pubKeyClient
privKeyClient=$(cat privKeyClient)
pubKeyClient=$(cat pubKeyClient)

ListenPort=$(cat $server | grep -E "ListenPort = " | grep -Eo "[0-9]+")
PublicAddress=$(curl ip.sb)
allowedips=$(cat $server | grep -E "Address = " | grep -Eo "([0-9]+\.)+")0/24

read -p "Please enter the public key of your server:" -i $(cat pubkey) -e srvPubKey
read -p "Please enter the domain/IP and port of your server[$PublicAddress:$ListenPort]:" -i "$PublicAddress:$ListenPort" -e endpoint
read -p "Please enter the range of allowed ips[0.0.0.0/0]:" -i $allowedips -e allowedips
echo "There has been $(cat $server | grep -Eo "\[Peer\]" | wc -l) peers existing, with 1 server config file there"
read -p "Please enter the client internal address in the LAN [e.g. 192.0.0.1/32]" -e clientInternalIP
read -p "Please enter DNS[1.1.1.1]:" -i "1.1.1.1" -e DNS
read -p "Please enter MTU[1420]" -i "1420" -e MTU
read -p "Please enter the private key of your client["+$privKeyClient+"]:" -i $privKeyClient -e clientPrivKey
read -p "Name of your config?[client.conf]:" -i "client.conf" -e configName

echo "
[Interface]
PrivateKey = $clientPrivKey
Address = $clientInternalIP
DNS = $DNS
MTU = $MTU

[Peer]
PublicKey = $srvPubKey
AllowedIPs = $allowedips
Endpoint = $endpoint
PersistentKeepalive = 25
" > $configName

pubKeyClient=$(echo $privKeyClient | wg pubkey)
echo "###### Your client public key is  ######"

read -p "Please enter the public key of your client:" -i "$pubKeyClient" -e clientPubKey
ls "/etc/wireguard/" | grep -Ee "*.conf"
read -p "Name of your server config?[e.g. wg0.conf]:" -e configServer
read -p "Please enter the range of allowed ips[the last ip is $(tail -n 2 $configServer | grep -Eo '([0-9]+\.)+[0-9]+\/[0-9]+') ]:" -i "$clientInternalIP" -e allowedips

echo "
[Peer]
PublicKey = $clientPubKey
AllowedIPs = $allowedips
" >> $configServer

echo "###### Please run systemctl restart wg-quick@your-service-name then ######"

rm -f privKeyClient pubKeyClient
sed -Ei 's/(#net\.ipv4\.ip_forward=1)|(net\.ipv4\.ip_forward=0)/net\.ipv4\.ip_forward=1/g' /etc/sysctl.conf && sysctl -p
