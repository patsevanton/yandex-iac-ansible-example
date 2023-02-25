Create secret
```
kubectl create secret generic grafana-password --from-file=grafana-password.txt -n monitoring
```

In Import via grafana.com, put the dashboard id 7587 and click on Load.
