Create S3 by terraform-k8s-terragrunt-velero-s3

Download and install https://github.com/vmware-tanzu/velero/releases/download/v1.9.6/velero-v1.9.6-linux-amd64.tar.gz

Create credentials
```ini
[default]
  aws_access_key_id= from terraform-k8s-terragrunt-velero-s3
  aws_secret_access_key= from terraform-k8s-terragrunt-velero-s3
```

Change bucket to bucket name from terraform-k8s-terragrunt-velero-s3

```bash
helm_app_install.sh
```

```bash
export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgresql postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
```

```bash
kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace postgresql --image docker.io/bitnami/postgresql:15.2.0-debian-11-r2 --env="PGPASSWORD=$POSTGRES_PASSWORD" \
--command -- psql --host postgresql -U postgres -d postgres -p 5432
```

```SQL
CREATE TABLE large_test (num1 bigint, num2 bigint, num3 bigint);

INSERT INTO large_test (num1, num2, num3)
SELECT round(random()*10), round(random()*10), round(random()*10)
FROM generate_series(1, 20000000) s(i);
```


```SQL
SELECT SUM(num1) AS sum_num1,
       SUM(num2) AS sum_num2,
       SUM(num3) AS sum_num3
FROM large_test;
```

Устанавливаем бинарник velero 1.8.1

```bash
kubectl label volumesnapshotclasses.snapshot.storage.k8s.io yc-csi-snapclass \
velero.io/csi-volumesnapshot-class="true" && \
velero install \
  --backup-location-config s3Url=https://storage.yandexcloud.net,region=ru-central1 \
  --bucket velero-apatsev \
  --plugins velero/velero-plugin-for-aws:v1.3.0,velero/velero-plugin-for-csi:v0.2.0 \
  --provider aws \
  --secret-file ./credentials \
  --features=EnableCSI \
  --use-volume-snapshots=true \
  --snapshot-location-config region=ru-central1 \
  --use-restic
```
