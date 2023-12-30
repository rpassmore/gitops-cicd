Cluster setup for Talos on HomeLab

Setup argocd cd:

Setup Hashicorp HCP vault secrets [https://developer.hashicorp.com/vault/tutorials/hcp-vault-secrets-get-started/kubernetes-vso]

The `hashicorp/vault-secrets-operator` should be installed by argocd.

But the secrets used to access the Hashicorp hcp vault secrets need to be manually setup.

Get the `HCP_CLIENT_ID` & `HCP_CLIENT_SECRET` from [https://portal.cloud.hashicorp.com/services/secrets/apps/home-lab/secrets?importActive=false&project_id=ff6aae5e-b7f0-4ca4-a9b5-a3fabb71a864]
Create a Kubernetes secret for the HCP service principal credentials.
```
kubectl create namespace ngrok-ingress
```

```
 kubectl create secret generic vso-demo-sp \
    --namespace ngrok-ingress \
    --from-literal=clientID=$HCP_CLIENT_ID \
    --from-literal=clientSecret=$HCP_CLIENT_SECRET
```
Example output:
```
secret/vso-demo-sp created
```
