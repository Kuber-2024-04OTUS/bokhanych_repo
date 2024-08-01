# CONSUL INSTALL:
```
helm repo add hashicorp https://helm.releases.hashicorp.com
helm search repo hashicorp/consul
#helm pull hashicorp/consul --untar
helm install consul hashicorp/consul --set global.name=consul --create-namespace -n consul -f consul/values.yaml

# ingress for ui
kubectl apply -f consul/ingress.yaml
```

# VAULT INSTALL:
```
helm repo add hashicorp https://helm.releases.hashicorp.com
helm search repo hashicorp/vault
helm install vault hashicorp/vault --create-namespace -n vault -f vault/values.yaml

# ingress for ui
kubectl apply -f vault/ingress.yaml
```

# VAULT INIT AND UNSEAL:
```
kubectl exec -it vault-0 -n vault -- vault operator init

kubectl exec -it vault-0 -n vault -- vault operator unseal
kubectl exec -it vault-1 -n vault -- vault operator unseal
kubectl exec -it vault-2 -n vault -- vault operator unseal
```

* helm upgrade consul hashicorp/consul -n consul -f consul/values.yaml
* helm upgrade vault hashicorp/vault -n vault -f vault/values.yaml

# Создаем хранилище секретов и секрет
```
kubectl exec -it vault-0 -n vault -- vault secrets enable -path otus -version=2 kv
kubectl exec -it vault-0 -n vault -- vault kv put otus/cred username=otus password=asajkjkahs
```

# ServiceAccount:
```
kubectl apply -f accounts.yaml
```

# Включаем и конфигурируем авторизацию auth/kubernetes
```
kubectl exec -it vault-0 -n vault -- vault auth enable kubernetes

TOKEN_REVIEW_JWT=$(kubectl get secret -n vault vault-auth -o go-template='{{ .data.token }}' | base64 --decode)

KUBE_CA_CERT=$(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 --decode)

KUBE_HOST=$(kubectl config view --raw --minify --flatten --output='jsonpath={.clusters[].cluster.server}')

kubectl exec -it vault-0 -n vault -- vault write auth/kubernetes/config token_reviewer_jwt="$TOKEN_REV
IEW_JWT" kubernetes_host="$KUBE_HOST" kubernetes_ca_cert="$KUBE_CA_CERT"

```

# Создайте и примените политику otus-policy для секретов /otus/cred
```
kubectl exec -it vault-0 -n vault -- vault policy write otus-policy - <<EOF
path "otus/cred" {
  capabilities = ["read", "list"]
}
EOF
```

# Создайте роль auth/kubernetes/role/otus в vault с использованием ServiceAccount vault-auth из namespace Vault и политикой otus-policy
```
kubectl exec -it vault-0 -n vault -- vault write auth/kubernetes/role/otus bound_service_account_names="vault-auth" bound_service_account_namespaces="vault" policies="otus-policy" ttl="1000h"
```

# Установите External Secrets Operator
```
helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets --namespace=vault external-secrets/external-secrets
```

# Создайте и примените манифест crd объекта SecretStore
```
curl --request POST --data '{"jwt": "'$TOKEN_REVIEW_JWT'", "role": "otus"}' http://vault.homework/v1/auth/kubernetes/login
echo -n <ключ с прошлого шага> | base64

kubectl apply -f secret-vault-token.yaml 
kubectl apply -f secret-store.yaml
kubectl apply -f secret-external.yaml
```