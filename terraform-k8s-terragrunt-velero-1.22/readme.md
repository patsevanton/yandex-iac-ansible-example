Устанавливаем бинарник velero 1.8.1
Download and install https://github.com/vmware-tanzu/velero/releases/download/v1.8.1/velero-v1.8.1-linux-amd64.tar.gz

Create credentials
```ini
[default]
  aws_access_key_id= from terraform-k8s-terragrunt-velero-s3
  aws_secret_access_key= from terraform-k8s-terragrunt-velero-s3
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
#velero backup create postgresql --include-resources pvc,pv --selector app.kubernetes.io/name=postgresql --include-namespaces postgresql
#velero restore create postgresql --exclude-namespaces velero --from-backup postgresql
velero restore create postgresql --exclude-namespaces velero --include-resources=pv,pvc --from-backup postgresql
```
