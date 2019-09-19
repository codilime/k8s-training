# 005-helm

Init helm's Tiller:
```
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account=tiller --wait
```

Install DokuWiki:
```
helm install --name test --set service.type=NodePort stable/dokuwiki
```

Change app svc type to NodePort
```
kubectl edit service app
```

Install nginx ingress:
```
helm install stable/nginx-ingress
```

Apply ingress 'config':
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: my-ingress-wiki
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /
        backend:
          serviceName: test-dokuwiki
          servicePort: 80
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: my-ingress-app
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  rules:
  - http:
      paths:
      - path: /app(/|$)(.*)
        backend:
          serviceName: app
          servicePort: 5000
```
