# k8s-training

## Before you begin
Install `gcloud`:
```
https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu
```

Install `kubectl`:
```
https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux
```

Authenticate `gcloud`:
```
gcloud auth login
```

Configure docker to use gcloud for authentication to `gcr.io` registries:
```
gcloud auth configure-docker
```

Install Helm **client** (do not care about Tiller at the moment):
```
https://helm.sh/docs/using_helm/#installing-helm
```

Create k8s cluster
