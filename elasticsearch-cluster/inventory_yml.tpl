all:
  children:
    elasticsearch_cluster:
      hosts:
%{~ for index, public_ip in elasticsearch_public_ip }
        elasticsearch${index}:
          ansible_host: ${public_ip}
%{~ endfor }
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
