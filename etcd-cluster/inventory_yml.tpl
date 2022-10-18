all:
  children:
    etcd:
      hosts:
%{~ for index, public_ip in etcd-cluster_public_ip }
        etcd{index}:
          ansible_host: ${public_ip}
%{~ endfor }
    etcd_master:
      hosts:
%{~ for index, public_ip in etcd-cluster_public_ip }
        etcd{index}:
          ansible_host: ${public_ip}
%{~ endfor }
  vars:
    ansible_user:  ${ssh_user}
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
