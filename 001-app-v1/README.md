# 001-app-v1

Set image name
```
IMAGE=gcr.io/project-name/app:v1
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
