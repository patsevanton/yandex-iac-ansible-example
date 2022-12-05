#!/bin/bash

set -eu pipefail

export bucket=$(terraform output --raw yandex_storage_bucket_velero_bucket)

kubectl label volumesnapshotclasses.snapshot.storage.k8s.io yc-csi-snapclass \
velero.io/csi-volumesnapshot-class="true" && \
velero install \
  --backup-location-config s3Url=https://storage.yandexcloud.net,region=ru-central1 \
  --bucket $bucket \
  --plugins velero/velero-plugin-for-aws:v1.3.0,velero/velero-plugin-for-csi:v0.2.0 \
  --provider aws \
  --secret-file ./credentials \
  --features=EnableCSI \
  --use-volume-snapshots=true \
  --snapshot-location-config region=ru-central1

