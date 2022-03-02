read -p "Please enter the public key of your client:" -e clientPubKey
read -p "Please enter the range of allowed ips[ 192.0.0.2/24 ]:" -i "192.0.0.2/24" -e allowedips
read -p "Name of your config?[e.g. wg0.conf]:" -e configName

echo "
[Peer]
PublicKey = $clientPubKey
AllowedIPs = $allowedips

" >> $configName
