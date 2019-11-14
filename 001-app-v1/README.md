# 001-app-v1

Set image name
```
IMAGE="gcr.io/$(gcloud config list --format 'value(core.project)' | tr -d '\n')/app:v1"
```

Build docker image
```
docker build -t $IMAGE .
```

Push image to GCR
```
docker push $IMAGE
```

Create Pod YAML:
```
kubectl run app --image=$IMAGE --restart=Never --dry-run -o yaml > pod.yaml
```

Apply the YAML:
```
kubectl apply -f pod.yaml
```

Show the Pod:
```
kubectl get pod
```

See if this works:
```
kubectl port-forward pod/app 5000:5000
curl 127.0.0.1:5000
```

Clean up:
```
kubectl delete -f pod.yaml
```
