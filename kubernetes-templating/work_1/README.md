helm repo add stable https://charts.helm.sh/stable
helm dependency build
helm install app ./work_1

```
# helm install app ./work_1/
NAME: app
LAST DEPLOYED: Tue May 28 15:12:47 2024
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:
Service is UP.
- URL: http://homework.otus
- IP: 157.90.28.247
```