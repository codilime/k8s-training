# 007-events

Create and apply Deployment YAML:
```
kubectl run app --image=nginx --replicas=20 --dry-run -o yaml > deployment.yaml
kubectl apply -f deployment.yaml
```

See the rollout status:
```
kubectl rollout status deployment app
```

Check out what's wrong:
```
kubectl get pods
```

See why a Pod is in a pending state:
```
kubectl describe pod `kubectl get pod --no-headers | grep Pending | head -n 1 | awk '{ print $1 }'`
```

Run "bulk describe":
```
kubectl get events
```

Play with filtering:
```
kubectl get events --field-selector involvedObject.kind=Deployment
kubectl get events --field-selector involvedObject.kind=Pod

kubectl get events --field-selector type=Warning
```
