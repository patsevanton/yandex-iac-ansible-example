%{ for index,public_ip in public_ips_master ~}
master${index} ansible_host=${ public_ips_master["${ index }"]} ip=${ private_ips_master["${ index }"] } roles=data,master
%{ endfor ~}
%{ for index,public_ip in public_ips_data~}
data${ index } ansible_host=${ public_ips_data["${ index }"] } ip=${ private_ips_data["${ index }"] } roles=data,ingest
%{ endfor ~}
%{ for index,public_ip in public_ips_dashboard ~}
dashboard${ index} ansible_host=${ public_ips_dashboard["${ index }"]} ip=${ private_ips_dashboard["${ index }"] }
%{ endfor ~}

[os-cluster]
%{ for index,public_ip in public_ips_master ~}
master${ index }
%{ endfor ~}
%{ for index, public_ip in public_ips_data ~}
data${ index }
%{ endfor ~}
%{ for index, public_ip in public_ips_dashboard ~}
dashboard${ index}
%{ endfor ~}

[master]
%{ for index,public_ip in public_ips_master ~}
master${ index }
%{ endfor ~}

[dashboard]
%{ for index, public_ip in public_ips_dashboard ~}
dashboard${ index}
%{ endfor ~}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa
domain_name=opensearch.local
os_download_url=https://artifacts.opensearch.org/releases/bundle/opensearch
os_version=1.3.0
os_user=opensearch
cluster_type=multi-node
os_cluster_name=opensearch
xms_value=8
xmx_value=8