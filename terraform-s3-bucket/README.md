### Velero pod status
```commandline
kubectl get pods -n velero
```

### Velero logs
```commandline
kubectl logs deployment/velero -n velero
```

### Back up data from the Managed Service for Kubernetes
```commandline
velero backup create my-backup
```