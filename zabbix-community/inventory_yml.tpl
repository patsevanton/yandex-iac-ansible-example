all:
  children:
    zabbix:
      hosts:
        zabbix_server:
          ansible_host: ${zabbix_server_public_ip}
          zabbix_server_real_dbhost: ${zabbix_database_public_ip}
          zabbix_server_dbhost: ${zabbix_database_public_ip}
          zabbix_server_dbname: zabbix-server
          zabbix_server_dbuser: zabbix-server
          zabbix_server_dbpassword: supersecure
          zabbix_api_server_url: "http://zabbix.${zabbix_server_public_ip}.${domain}"
        zabbix_database:
          ansible_host: ${zabbix_database_public_ip}
          postgresql_listen_addresses: "*"
          postgresql_users:
            - name: zabbix-server
              password: supersecure
          postgresql_databases:
            - name: zabbix-server
              owner: zabbix-server
          postgresql_pg_hba_custom:
            - {type: "host", database: "all", user: "all", address: "${zabbix_server_public_ip}/32", method: "md5" }
          #postgresql_hba_entries:
          #  - { type: local, database: all, user: postgres, auth_method: peer }
          #  - { type: local, database: all, user: all, auth_method: peer }
          #  - { type: host, database: all, user: all, address: '127.0.0.1/32', auth_method: md5 }
          #  - { type: host, database: all, user: all, address: '::1/128', auth_method: md5 }
          #  - { type: host, database: all, user: all, address: '${zabbix_server_public_ip}/32', auth_method: md5 }

  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
