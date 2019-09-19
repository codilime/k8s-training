# 004-app-v3-volumes-jobs

Set image name
```
IMAGE=gcr.io/project-name/app:v3
```

Build docker image
```
docker build -t $IMAGE .
```

Push image to GCR
```
docker push $IMAGE
```

Create Deployment/Service YAML:
```
kubectl run app --image=$IMAGE --replicas=3 --port 5000 --expose --dry-run -o yaml > deployment_service.yaml
```

Create configmap 1 YAML:
```
kubectl create configmap cm1 --from-file=foo --from-file=bar --dry-run -o yaml > cm1.yaml
```

Create configmap 2 YAML:
```
kubectl create configmap cm2 --from-literal=asdf=fdsa --dry-run -o yaml > cm2.yaml
```

Create secret YAML:
```
kubectl create secret generic vault --from-literal=password=hunter2 --dry-run -o yaml > secret.yaml
```

Create PVC:
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: dont-die
spec:
  resources:
    requests:
      storage: 200Mi
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
```

Create job YAML:
```
kubectl create job filler --image=alpine --dry-run -o yaml > job.yaml
```

Add command:
```
command:
- sh
- -c
- touch /media/hdd/what && touch /media/hdd/is && touch /media/hdd/that
```

Define PVC volume:
```
volumes:
- name: hdd
  persistentVolumeClaim:
    claimName: dont-die
```

Mount PVC:
```
volumeMounts:
- name: hdd
  mountPath: /media/hdd
```

Create the resources:
```
kubectl apply -f cm1.yaml -f cm2.yaml -f secret.yaml
```

Update the deployment:
```
env:
- name: PASSWORD
  valueFrom:
    secretKeyRef:
      name: vault
      key: password
volumeMounts:
- name: first
  mountPath: /media/one
- name: second
  mountPath: /media/two
- name: hdd
  mountPath: /media/hdd
volumes:
- name: first
  configMap:
    name: cm1
- name: second
  configMap:
    name: cm2
- name: hdd
  persistentVolumeClaim:
    claimName: hdd
```

Check if this worked:
```
kubectl get pods
kubecrl describe pod `kubectl get pod --no-headers | head -n 1 | awk '{ print $1 }'`
kubectl run curler --image=pstauffer/curl --restart=Never -it -- sh
$ curl service-ip:5000/env?name=PASSWORD
$ curl service-ip:5000/dir?path=media
$ curl service-ip:5000/dir?path=media/one
$ curl service-ip:5000/dir?path=media/two
$ curl service-ip:5000/dir?path=media/hdd
```

Clean up:
```
kubectl delete -f deployment_service.yaml
```
