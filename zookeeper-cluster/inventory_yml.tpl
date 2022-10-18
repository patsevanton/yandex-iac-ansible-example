all:
  children:
    zookeepers:
      hosts:
%{~ for index, public_ip in zookeeper_public_ip }
        zookeeper${index}:
          ansible_host: ${public_ip}
%{~ endfor }
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa  
    zookeeper_hosts:
%{ for index, public_ip in zookeeper_public_ip ~}
      - { host: "zookeeper${index}", id: ${ index } }
%{ endfor ~}
