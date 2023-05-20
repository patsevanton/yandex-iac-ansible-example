# infrastructure-as-a-code-example
Examples of infrastructure as code tools include Yandex Cloud, Terraform and Ansible.
Terraform code don`t use managed service in Yandex Cloud.

## Install YC cli
```
curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```

## Init YC cli
```
yc init
```

## Get token, cloud-id, folder-id
```
yc config list
```
Output:
```
token: xxx
cloud-id: xxx
folder-id: xxxx
compute-default-zone: ru-central1-b
```

# Terraform
## Set up terraform
### Download terraform https://hashicorp-releases.yandexcloud.net/terraform/
```
unzip terraform_1.2.4_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

### Set terraform mirror
```
nano ~/.terraformrc
```
with code
```
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```


### terraform fmt for private.auto.tfvars.example
```
find . -iname 'private.auto.tfvars.example' -execdir mv -i '{}' private.auto1.tfvars \;
terraform fmt -recursive
find . -iname 'private.auto1.tfvars' -execdir mv -i '{}' private.auto.tfvars.example \;
```

# Ansible
## Install Ansible
```
sudo add-apt-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible
```
## Setting for ubuntu 22.04
```
sudo apt install python3-resolvelib=0.5.4-1ppa~jammy
sudo apt-mark hold python3-resolvelib
```

# SSH
```
cat .ssh/config 
Host *
    StrictHostKeyChecking no
    ServerAliveInterval 5
    HashKnownHosts no
```
