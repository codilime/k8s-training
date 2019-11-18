# 007-network-policy

## Initial setup
Set image name
```
IMAGE="gcr.io/$(gcloud config list --format 'value(core.project)' | tr -d '\n')/app:v4"
```

Build docker image
```
docker build -t $IMAGE .
```

Push image to GCR
```
docker push $IMAGE
```

Create Deployment 3 times, exposing each of them:
```
kubectl run app1 --image=$IMAGE --expose --port=5000
kubectl run app2 --image=$IMAGE --expose --port=5000
kubectl run app3 --image=$IMAGE --expose --port=5000
```


## Check application logs
```
kubectl logs -l run=app1
kubectl logs -l run=app2
kubectl logs -l run=app3
```


## Apply NetworkPolicy
```
kubectl create -f network_policy.yaml
```

## Check the logs again
```
kubectl logs -l run=app1
kubectl logs -l run=app2
kubectl logs -l run=app3
```

Clean up:
```
kubectl delete -f deployment.yaml
kubectl delete -f network_policy.yaml
```
