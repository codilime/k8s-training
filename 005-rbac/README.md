# 005-rbac

Create service account:
```
kubectl create serviceaccount reader
```

Run pod with kubectl:
```
kubectl run kubectl --command bash --rm --image=bitnami/kubectl --restart=Never -it --serviceaccount=reader
```

Try to get pods:
```
$ kubectl get pod
```

Create role:
```
kubectl create role reader --verb=list --resource=pods
```

Bind the role to service account:
```
kubectl create rolebinding reader --role=reader --serviceaccount=default:reader
```

Try it out:
```
$ kubectl get pod
$ kubectl get pod kubectl
```

Modify the role to fulfill the needs:
```
kubectl edit role reader
```
