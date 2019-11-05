# 005-rbac

## RBAC-related k8s objects:

1. List service accounts:
   ```
   kubectl get serviceaccount --all-namespaces
   ```
2. Get details of specific account:
   ```
   kubectl get serviceaccount default -n kube-public -oyaml
   ```
3. List roles:
   ```
   # For Roles
   kubectl get role --all-namespaces
   # For ClusterRoles
   kubectl get clusterrole
   ```
4. Get details of a specific (cluster)role:
   ```
   kubectl get clusterrole view -oyaml
   kubectl get clusterrole system:node -oyaml # used by kubelets
   ```
5. List (cluster) role bindings:
   ```
   kubectl get rolebinding --all-namespaces
   # or for cluster-wide bindings
   kubectl get clusterrolebinding
   ```
6. Get details of (cluster) role binding:
   ```
   kubectl get clusterrolebinding cluster-admin -oyaml
   ```
   
## RBAC in action

1. Create a (oneshot) pod that will watch the pods running in the cluster:
   ```
   kubectl run pod-watcher --generator=run-pod/v1 -it --rm --image=bitnami/kubectl --restart=Never -- get pod
   ```
2. Create service account and assign clusterrole view
   ```
   kubectl apply -f view-all.yaml
   ```
3. Use created service account this time:
   ```
   kubectl run pod-watcher --generator=run-pod/v1 -it --rm --image=bitnami/kubectl --restart=Never --serviceaccount=default:all-seeing-eye -- get pod
   kubectl run pod-watcher --generator=run-pod/v1 -it --rm --image=bitnami/kubectl --restart=Never --serviceaccount=default:all-seeing-eye -- get pod --all-namespaces
   kubectl run pod-watcher --generator=run-pod/v1 -it --rm --image=bitnami/kubectl --restart=Never --serviceaccount=default:all-seeing-eye -- get deployment
   ```
4. Create limited access role and rolebinding:
   ```
   kubectl delete -f view-all.yaml
   kubectl apply -f view-pods.yaml
   
   kubectl run pod-watcher --generator=run-pod/v1 -it --rm --image=bitnami/kubectl --restart=Never --serviceaccount=default:pods-seeing-eye -- get pod
   kubectl run pod-watcher --generator=run-pod/v1 -it --rm --image=bitnami/kubectl --restart=Never --serviceaccount=default:pods-seeing-eye -- get pod --all-namespaces
   kubectl run pod-watcher --generator=run-pod/v1 -it --rm --image=bitnami/kubectl --restart=Never --serviceaccount=default:pods-seeing-eye -- get deployment
   ```
   
