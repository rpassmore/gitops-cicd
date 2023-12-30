# gitops-cicd

Deploy Argocd to the cluster then have Argocd manage itself.
Argocd then deploys:
- Metallb, as the loadbalencer
- Traefik, as ingress contoller for local network
- Ngrok, as ingress contoller for internet based access
- Hashicorp HCP vault and `vault-secrets-operator` to manage secrets
- kube-prometheus-stack including grafana to provide cluster monitoring
- Grana dashboards from https://github.com/rpassmore/grafana-dashboards-kubernetes