[zabbix_server]
zabbix_server ansible_host=${zabbix_server_public_ip}

[zabbix_database]
zabbix_database ansible_host=${zabbix_database_public_ip}

[database:children]
zabbix_database
zabbix_proxy

# Connection settings
[all:vars]
ansible_user=${ssh_user}
ansible_ssh_private_key_file=~/.ssh/id_rsa
