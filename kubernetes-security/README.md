**Порядок запуска**
```
# kubectl apply -f namespace.yaml && kubectl apply -f configmaps.yaml && kubectl apply -f storages.yaml && kubectl apply -f accounts.yaml && kubectl apply -f deployment.yaml && kubectl apply -f services.yaml

namespace/homework created
configmap/bokhanych-configmap created
configmap/nginx-conf created
storageclass.storage.k8s.io/bokhanych-storageclass unchanged
persistentvolumeclaim/bokhanych-pvc created
serviceaccount/monitoring-service-account created
serviceaccount/cd created
secret/cd-token created
clusterrole.rbac.authorization.k8s.io/metrics-reader unchanged
clusterrolebinding.rbac.authorization.k8s.io/metrics-reader-binding unchanged
role.rbac.authorization.k8s.io/admin created
rolebinding.rbac.authorization.k8s.io/admin-binding created
deployment.apps/web-server-deployment created
service/web-server-service created
ingress.networking.k8s.io/main-ingress created
```

**Получение токена для service account cd**
```
# kubectl get serviceaccount cd -n homework -o jsonpath='{.secrets[0].name}'
# kubectl get secret cd-token -n homework -o jsonpath='{.data.token}' | base64 --decode
eyJhbGciOiJSUzI1NiIsImtpZCI6IlZHdm9aV1BwMG52WDlEaUctMXQyUHMtVHdTM3g4OHotTmFKZEpDSF9UOXMifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJob21ld29yayIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJjZC10b2tlbiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJjZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjY4ZDE0YmJkLTIxYjUtNDk2My1hOTI1LWIwYjNhZTdmNDA1ZiIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpob21ld29yazpjZCJ9.g-XhPMM3bXjLrGk2MOXBcZwx2TvyQaE_Z991Jwmty2YlpvesSoZjxO-chcfTpTUIVuKj4IC5Ek5SAFOPiqOJKMpiw3NP4jICGXXS-eETjTswWclDfCd9kRv2amV-G5nmMDTF4a_cbkSMCZVCEou1kgA4hXxeCp4I7584TFnHO80UYstN0I56lFZ8K3pDeyNGonZJSmB_NR6FI0pqGVMLhqH53-7qfZC3l-L16_z45MuURpQYdNqGR7soY6Yq4HB8-rJ_PMvPFNtv3W1o7a0xLJs2YrNpE7PR7g52YbKK4CBJkhhpDtjUW2OITUyU2-vT-e2_-Vg9io522qeGN5Mwlw
# kubectl get secret cd-token -n homework -o jsonpath='{.data.token}' | base64 --decode > token
```