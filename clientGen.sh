wg genkey | tee privKeyClient
cat privKeyClient | wg pubkey | tee pubKeyClient
privKeyClient=$(cat privKeyClient)
pubKeyClient=$(cat pubKeyClient)

read -p "Please enter the public key of your server:" -i $(cat pubkey) -e srvPubKey
read -p "Please enter the domain/IP and port of your server[e.g. example.com:21111]:" -e endpoint
read -p "Please enter the range of allowed ips[0.0.0.0/0]:" -i "0.0.0.0/0" -e allowedips
echo "There has been $(cat mygame.conf | grep -Eo "\[Peer\]" | wc -l) peers existing"
read -p "Please enter the internal address in the LAN [e.g. 192.0.0.1/32]" -e clientInternalIP
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
ls /etc/wireguard | grep -Ee "*.conf"
read -p "Name of your server config?[e.g. wg0.conf]:" -e configName
read -p "Please enter the range of allowed ips[the last ip is $(tail -n 2 $configName | grep -Eo '([0-9]+\.)+[0-9]+\/[0-9]+') ]:" -i "$clientInternalIP" -e allowedips

echo "
[Peer]
PublicKey = $clientPubKey
AllowedIPs = $allowedips

" >> $configName
