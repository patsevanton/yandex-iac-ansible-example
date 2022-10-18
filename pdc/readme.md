## Создание Active Directory (Domain Controller) в Yandex Cloud с помощью terraform and ansible.

В этом примере происходит создание серверов в Yandex Cloud c помощью terraform.


### Установите yandexcloud cli
```
curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```

### Инициализируйте yandexcloud cli
```
yc init
```

### Получите token, cloud-id, folder-id
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

### Создайте private.auto.tfvars из примера private.auto.tfvars.example
Скопируйте или переименуйте private.auto.tfvars.example в private.auto.tfvars, заполните yc_token,
yc_cloud_id, yc_folder_id.

Укажите yc_zone - avalability zone по умолчанию.

Укажите pdc_admin_password как пароль локального Administrator Windows. 

Укажите pdc_hostname как имя сервера.

Укажите название домена pdc_domain, например "ad.domain.test".

Укажите pdc_domain_path, например "dc=ad,dc=domain,dc=test".

Укажите pfx_password, например "P@ssw0rd".


### Условные обозначения
pdc - primarydomaincontroller
