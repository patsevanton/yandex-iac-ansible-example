all:
  children:
    kafka_cluster:
      hosts:
%{~ for index, public_ip in kafka_public_ip }
        kafka${index}:
          ansible_host: ${public_ip}
%{~ endfor }
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa  
    zookeeper_hosts:
%{ for index, public_ip in kafka_public_ip ~}
      - { host: "kafka${index}", id: ${ index } }
%{ endfor ~}
