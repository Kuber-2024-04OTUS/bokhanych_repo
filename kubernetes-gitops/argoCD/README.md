**ArgoCD install:**
```
# Helm pull:
helm pull oci://cr.yandex/yc-marketplace/yandex-cloud/argo/chart/argo-cd --version 5.46.8-6 --untar

# Helm install with my values:
helm install --namespace argocd --create-namespace argo-cd ./argo-cd/ -f values.yaml

# Get secret:
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Port forward (access https://localhost:8080):
kubectl port-forward service/argo-cd-argocd-server --namespace argocd 8080:443
```


https://localhost:8080/applications?showFavorites=false&proj=&sync=&autoSync=&health=&namespace=&cluster=&labels=