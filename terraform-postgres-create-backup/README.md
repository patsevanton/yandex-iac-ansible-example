```
pgbench "host=rc1b-xxx.mdb.yandexcloud.net port=6432 sslmode=verify-full dbname=test  user=test target_session_attrs=read-write" -i
pgbench "host=rc1b-xxxx.mdb.yandexcloud.net port=6432 sslmode=verify-full dbname=test  user=test target_session_attrs=read-write" -T 3600
```

```
export IAM_TOKEN=`yc iam create-token`
curl -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${IAM_TOKEN}" \
        -G 'https://monitoring.api.cloud.yandex.net/monitoring/v2/metrics/?folderId=xxxx&pageSize=200' --data-urlencode 'selectors={service="managed-postgresql", resource_id="xxxxx"}' | jq .metrics[] | jq -s 'sort_by(.name)' >  with-stats.json
```

