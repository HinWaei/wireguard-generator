#!/bin/bash
echo "Please enter the server internal IP[e.g. 192.168.0.1/24]:"
read srvInternalIP
echo "Please enter the listening port[21111]:"
read -i "21111" -e srvExternalPort
echo "Please enter config name[wg0]:"
read -i "wg0" -e configName
echo "Please enter forward network device name[eth0]:"
read -i "eth0" -e dev
echo "Please enter DNS[1.1.1.1]:"
read -i "1.1.1.1" -e DNS
read -p "Please enter MTU [1420]:" -i "1420" -e MTU

wg genkey | tee privkey
cat privkey | wg pubkey | tee pubkey
privkey=$(cat privkey)
pubkey=$(cat pubkey)

echo "
[Interface]
PrivateKey = $privkey
Address = $srvInternalIP
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $dev -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $dev -j MASQUERADE
ListenPort = $srvExternalPort
DNS = $DNS
MTU = $MTU
" > $configName.conf

echo "

Please do remember to turn on ip forward: i.e. net.ipv4.ip_forward = 1
"



