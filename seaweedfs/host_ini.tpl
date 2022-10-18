[seaweedfs]
"${hostname}" ansible_host="${public_ip}"

[seaweedfs:vars]
seaweedfs_external_url="https://${hostname}.${public_ip}.${domain}"
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa
