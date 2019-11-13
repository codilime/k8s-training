# 004-app-v3-volumes-jobs

## Prepare app
Set image name
```
IMAGE="gcr.io/$(gcloud config list --format 'value(core.project)' | tr -d '\n')/app:v3"
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
kubectl apply -f deployment_service.yaml
```

## Simple volumes
### Prepare ConfigMaps and Service
Create configmap 1 YAML from file:
```
kubectl create configmap cm1 --from-file=foo --from-file=bar --dry-run -o yaml > cm1.yaml
```

Create configmap 2 YAML from literal:
```
kubectl create configmap cm2 --from-literal=asdf=fdsa --dry-run -o yaml > cm2.yaml
```

Create secret YAML:
```
kubectl create secret generic vault --from-literal=password=hunter2 --dry-run -o yaml > secret.yaml
```

Create the resources:
```
kubectl apply -f cm1.yaml -f cm2.yaml -f secret.yaml
```

### Attach the volumes
Update the deployment's spec with `volumes` and `volumesMounts`:
```
kubectl edit deployments app
```
or
```
you_fav_editor_vim deployment_service.yaml && kubectl apply -f deployment_service.yaml
```

```yaml
    spec:
      containers:
      - image: ${IMAGE}
        name: app
        ports:
        - containerPort: 5000
        resources: {}
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
      volumes:
      - name: first
        configMap:
          name: cm1
      - name: second
        configMap:
          name: cm2
```

### Check if this worked:
```
kubectl get pods
kubecrl describe pod `kubectl get pod --no-headers | head -n 1 | awk '{ print $1 }'`
kubectl run curler --image=pstauffer/curl --restart=Never -it -- sh
$ curl app:5000/env?name=PASSWORD
$ curl app:5000/dir?path=/media
$ curl app:5000/dir?path=/media/one
$ curl app:5000/dir?path=/media/two
$ exit
```

## Advanced volumes
### Create persistent volume
Create GCP Disk:
```
gcloud compute disks create permanent-record --size 1Gi --zone europe-west4-b
```

Create Persistent Volume with two `accessModes`:
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 200Mi
  accessModes:
    - ReadWriteOnce
    - ReadOnlyMany
  gcePersistentDisk:
    pdName: permanent-record
    fsType: ext4
```

See PV status - Available:
```
kubectl get pv
```

Create Persistent Volume Claim:
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
    - ReadOnlyMany
  storageClassName: manual
```

See PV status - Bound:
```
kubectl get pv
kubectl get pvc
```

### Fill the persistent volume with Job
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

Run the Job:
```
kubectl apply -f job
```

Confirm Job is completed:
```
kubectl get job
```

Delete Job:
```
kubectl delete -f job.yaml
```

### Attach the volume
Update the deployment:
```
volumesMounts:
- name: hdd
  mountPath: /media/hdd
volumes:
- name: hdd
  persistentVolumeClaim:
    claimName: dont-die
```

Check if this worked:
```
kubectl get pods
kubecrl describe pod `kubectl get pod --no-headers | head -n 1 | awk '{ print $1 }'`
kubectl run curler --image=pstauffer/curl --restart=Never -it -- sh
$ curl app:5000/dir?path=/media/hdd
$ exit
```

Clean up:
```
kubectl delete -f cm1.yaml -f cm2.yaml -f secret.yaml -f deployment_service.yaml
kubectl delete pv --all
kubectl delete pvc --all
gcloud compute disks delete permanent-record --zone=europe-west4-b
```
