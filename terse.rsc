# feb/04/2025 01:09:07 by RouterOS 7.2.3
# software id = 
#
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/port
set 0 name=serial0
/user group
add name=SuporteN1 policy="local,read,winbox,password,!telnet,!ssh,!ftp,!reboo\
    t,!write,!policy,!test,!web,!sniff,!sensitive,!api,!romon,!dude,!rest-api"
/ip address
add address=199.1.1.1/24 interface=ether2 network=199.1.1.0
/ip dhcp-client
add interface=ether1
/ip dns
set servers=8.8.8.8
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
/ip route
add gateway=192.168.88.1
/ip service
set telnet disabled=yes
set ftp disabled=yes
set api disabled=yes
set winbox port=8597
set api-ssl disabled=yes
/system identity
set name="MikroTik  Provedor"
/tool romon
set enabled=yes
