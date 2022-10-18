all:
  children:
    clickhouse_cluster:
      hosts:
%{~ for index, public_ip in clickhouse_public_ip }
        clickhouse${index}:
          ansible_host: ${public_ip}
%{~ endfor }
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
    clickhouse_version: 22.1.4.30
    clickhouse_clusters:
      your_cluster_name:
        shard_1:
    %{~ for index, public_ip in clickhouse_public_ip ~}
          - { host: "clickhouse${index}", port: 9000 }
    %{~ endfor ~}     
    clickhouse_zookeeper_nodes:
%{~ for index, public_ip in clickhouse_public_ip }
      - { host: "clickhouse${index}", port: 2181 }
%{~ endfor }
    zookeeper_hosts:
%{ for index, public_ip in clickhouse_public_ip ~}
      - { host: "clickhouse${index}", id: ${ index } }
%{ endfor ~}
