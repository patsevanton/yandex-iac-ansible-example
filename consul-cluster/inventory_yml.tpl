all:
  children:
    consul_instances:
      hosts:
%{~ for index, public_ip in consul_public_ip }
        consul${index}:
          ansible_host: ${public_ip}
%{~ endfor }
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
