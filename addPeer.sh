read -p "Please enter the public key of your client:" -e clientPubKey
read -p "Name of your config?[e.g. wg0.conf]:" -e configName
read -p "Please enter the range of allowed ips[the last ip is $(tail -n 2 $configName | grep -Eo '([0-9]+\.)+[0-9]+\/[0-9]+') ]:" -e allowedips

echo "
[Peer]
PublicKey = $clientPubKey
AllowedIPs = $allowedips

" >> $configName
