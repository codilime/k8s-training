# 002-app-v1-deployment

Set image name
```
IMAGE=gcr.io/project-name/app:v1
```

Create Deployment YAML:
```
kubectl run app --image=$IMAGE --replicas=3 --dry-run -o yaml > deployment.yaml
```

Apply the YAML:
```
kubectl apply -f deployment.yaml
```

See if this works:
```
kubectl get deployments
kubectl get replicasets
kubectl get pods
```

Set new image name
```
IMAGE=gcr.io/project-name/app:v2
```

Build docker image
```
docker build -t $IMAGE .
```

Push image to GCR
```
docker push $IMAGE
```

Update image in deployment:
```
kubectl set image deployments/app app=$IMAGE
```

Check the progress:
```
kubectl rollout status deployments/app
kubectl get deployments
kubectl get replicasets
kubectl get pods
```

Check if new version is loaded:
```
kubectl port-forward pod/`kubectl get pod --no-headers | head -n 1 | awk '{ print $1 }'` 5000:5000
curl 127.0.0.1:5000
```

Clean up:
```
kubectl delete -f deployment.yaml
```
