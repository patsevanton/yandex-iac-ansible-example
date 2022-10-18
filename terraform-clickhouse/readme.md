wget https://storage.yandexcloud.net/arhipov/weather_data.tsv

```
clickhouse-client --host <адрес вашей БД> \
                  --secure \
                  --user user1 \
                  --database db1 \
                  --port 9440 \
                  --ask-password
```

```
cat weather_data.tsv | clickhouse-client \
--host <адрес вашей БД> \
--secure \
--user user1 \
--database db1 \
--port 9440 \
-q "INSERT INTO db1.Weather FORMAT TabSeparated" \
--ask-password
```