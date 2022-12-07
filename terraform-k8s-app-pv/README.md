### Create large ~1 GB random dataset in PostgreSQL

```
CREATE TABLE large_test (num1 bigint, num2 double precision, num3 double precision);

INSERT INTO large_test (num1, num2, num3)
  SELECT round(random()*10), random(), random()*142
  FROM generate_series(1, 20000000) s(i);
```

```
SELECT md5(array_agg(md5((t.*)::varchar))::varchar)
  FROM (
        SELECT *
          FROM large_test
         ORDER BY 1
       ) AS t;
```