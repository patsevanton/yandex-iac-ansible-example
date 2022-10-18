```
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
source /home/ubuntu/.bashrc
git clone https://github.com/yandex-cloud/ydb-python-sdk.git
sudo pip3 install iso8601 ydb yandexcloud
mkdir ~/.ydb
wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" -O ~/.ydb/CA.pem
yc iam key create \
  --folder-id <идентификатор каталога> \
  --service-account-name <имя сервисного аккаунта> \
  --output ~/.ydb/sa_name.json
export SA_KEY_FILE=~/.ydb/sa_name.json
export YDB_SSL_ROOT_CERTIFICATES_FILE=~/.ydb/CA.pem
```