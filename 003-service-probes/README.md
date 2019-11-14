# 002-app-v1-deployment

Set image name
```
IMAGE="gcr.io/$(gcloud config list --format 'value(core.project)' | tr -d '\n')/app:v2"
```

Create Deployment/Service YAML:
```
kubectl run app --image=$IMAGE --replicas=3 --port 5000 --expose --dry-run -o yaml > deployment_service.yaml
```

Apply the YAML:
```
kubectl apply -f deployment_service.yaml
```

See if this works:
```
kubectl run curler --image=pstauffer/curl --restart=Never -it -- sh
$ for x in `seq 1 10`; do curl service-ip:5000; done
```

Add liveness probe:
```
livenessProbe:
  httpGet:
    path: /
    port: 5000
    httpHeaders:
    - name: User-Agent
      value: U alive?
```

Add readiness probe:
```
readinessProbe:
  httpGet:
    path: /
    port: 5000
    httpHeaders:
    - name: User-Agent
      value: U ready?
```

Clean up:
```
kubectl delete -f deployment_service.yaml
kubectl delete pod curler
```
