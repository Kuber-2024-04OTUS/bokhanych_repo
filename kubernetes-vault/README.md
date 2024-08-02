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
path "otus/*" {
  capabilities = ["read", "list"]
}

path "/v1/otus/*" {
  capabilities = ["read", "list"]
}
EOF
```

# Создайте роль auth/kubernetes/role/otus в vault с использованием ServiceAccount vault-auth из namespace Vault и политикой otus-policy
```
kubectl exec -it vault-0 -n vault -- vault write auth/kubernetes/role/otus bound_service_account_names="vault-auth" bound_service_account_namespaces="vault" policies="otus-policy" ttl="300h"
```

# Установите External Secrets Operator
```
helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets --namespace=vault external-secrets/external-secrets
```

# Создайте и примените манифест crd объекта SecretStore
```
curl --request POST --data '{"jwt": "'$TOKEN_REVIEW_JWT'", "role": "otus"}' http://vault.homework/v1/auth/kubernetes/login

echo -n <ключ с курла> | base64

kubectl apply -f secret-vault-token.yaml 
kubectl apply -f secret-store.yaml
kubectl apply -f secret-external.yaml
```

# Проверка:
```
kubectl describe externalsecrets.external-secrets.io  -A
Name:         otus-external-secret
Namespace:    vault
Labels:       <none>
Annotations:  <none>
API Version:  external-secrets.io/v1beta1
Kind:         ExternalSecret
Metadata:
  Creation Timestamp:  2024-08-01T14:22:23Z
  Generation:          1
  Resource Version:    127100
  UID:                 d2fd104d-7c33-4510-bcdc-162432d55298
Spec:
  Data:
    Remote Ref:
      Conversion Strategy:  Default
      Decoding Strategy:    None
      Key:                  otus/cred
      Metadata Policy:      None
      Property:             username
    Secret Key:             username
    Remote Ref:
      Conversion Strategy:  Default
      Decoding Strategy:    None
      Key:                  otus/cred
      Metadata Policy:      None
      Property:             password
    Secret Key:             password
  Refresh Interval:         1h
  Secret Store Ref:
    Kind:  SecretStore
    Name:  vault-secret-store
  Target:
    Creation Policy:  Owner
    Deletion Policy:  Retain
    Name:             otus-cred
Status:
  Binding:
    Name:  otus-cred
  Conditions:
    Last Transition Time:   2024-08-01T14:22:23Z
    Message:                Secret was synced
    Reason:                 SecretSynced
    Status:                 True
    Type:                   Ready
  Refresh Time:             2024-08-01T14:22:23Z
  Synced Resource Version:  1-4145dbb39b277ce94d80d0d08075e0b1
Events:
  Type    Reason   Age   From              Message
  ----    ------   ----  ----              -------
  Normal  Created  4s    external-secrets  Created Secret
```