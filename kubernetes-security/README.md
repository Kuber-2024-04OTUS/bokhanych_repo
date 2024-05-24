**Порядок запуска**
```
kubectl apply -f namespace.yaml && kubectl apply -f configmaps.yaml && kubectl apply -f storages.yaml && kubectl apply -f accounts.yaml && kubectl apply -f deployment.yaml && kubectl apply -f services.yaml
```

**Получение токена для service account cd**
```
kubectl get serviceaccount cd -n homework -o jsonpath='{.secrets[0].name}'
kubectl get secret cd-token -n homework -o jsonpath='{.data.token}' | base64 --decode
kubectl get secret cd-token -n homework -o jsonpath='{.data.token}' | base64 --decode > token
```