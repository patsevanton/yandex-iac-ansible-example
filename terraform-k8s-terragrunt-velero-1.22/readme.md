Устанавливаем бинарник velero 1.8.1
https://github.com/vmware-tanzu/velero
Download and install
https://github.com/vmware-tanzu/velero/releases/download/v1.10.3/velero-v1.10.3-linux-amd64.tar.gz

Create credentials
```ini
[default]
  aws_access_key_id= from terraform-k8s-terragrunt-velero-s3
  aws_secret_access_key= from terraform-k8s-terragrunt-velero-s3
```

```bash
kubectx yc-test-1-22
```

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


```bash
velero restore get
velero restore create postgresql --exclude-namespaces velero --include-resources=pv,pvc --from-backup postgresql --include-namespaces postgresql
velero restore describe postgresql --details
```
