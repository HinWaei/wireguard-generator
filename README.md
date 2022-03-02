# wireguard-generator
A generator for configuration of Wireguard server and client

# Flow
1. Run __srvGen.sh__ at first according to the provided guide to generate a server config file
2. Execute __clientGen.sh__ to generate a client config file by inputing relevent information
3. It ends up with automatically running __addPeer.sh__ following the previous step.

# NOTE
In light of existing odd glitches in Wireguard, I suggest you turning AllowedIPs to be with the netmask of 255.255.255.255(i.e. xxx.xxx.xxx.xxx/32 in CIDR notatino) as adding an extra peer.
Please fill up each variable in the given format in case my poor double-checking code is stuck in malfunction. 💀
