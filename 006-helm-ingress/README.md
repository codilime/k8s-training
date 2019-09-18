# 005-helm

Init helm's Tiller:
```
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account=tiller --wait
```

Install DokuWiki:
```
helm install --set service.type=NodePort stable/dokuwiki
```

Change app svc type to NodePort
**TODO(kwapik):** provide command


**TODO(kwapik):** provide ingress config
