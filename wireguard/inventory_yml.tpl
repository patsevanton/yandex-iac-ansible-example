all:
  children:
    wireguard:
      hosts:
        "${hostname}":
          ansible_host: "${public_ip}"
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    wireguard_address: "10.27.123.1/24"
    wireguard_mtu: "1280"
    wireguard_postup:
      - iptables -t mangle -A POSTROUTING -p tcp --tcp-flags SYN,RST SYN -o eth0 -j TCPMSS --clamp-mss-to-pmtu
      - ip6tables -t mangle -A POSTROUTING -p tcp --tcp-flags SYN,RST SYN -o eth0 -j TCPMSS --clamp-mss-to-pmtu
      - iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
      - iptables -A FORWARD -i %i -j ACCEPT
      - ip6tables -A FORWARD -i %i -j ACCEPT
      - sysctl -q -w net.ipv4.ip_forward=1
      - sysctl -q -w net.ipv6.conf.all.forwarding=1
      - ufw allow 51820/udp
    wireguard_postdown:
      - iptables -D FORWARD -i %i -j ACCEPT
      - ip6tables -D FORWARD -i %i -j ACCEPT
      - iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
      - iptables -t mangle -D POSTROUTING -p tcp --tcp-flags SYN,RST SYN -o eth0 -j TCPMSS --clamp-mss-to-pmtu
      - ip6tables -t mangle -D POSTROUTING -p tcp --tcp-flags SYN,RST SYN -o eth0 -j TCPMSS --clamp-mss-to-pmtu
      - sysctl -q -w net.ipv4.ip_forward=0
      - sysctl -q -w net.ipv6.conf.all.forwarding=0
