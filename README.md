# gitops-cicd

Deploy Argocd to the cluster then have Argocd manage itself.
Argocd then deploys:
- Metallb, as the loadbalencer
- Traefik, as ingress contoller for local network
- Ngrok, as ingress contoller for internet based access
- ? to manage secrets