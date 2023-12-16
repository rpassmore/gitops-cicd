#!/bin/bash
#kubectl create namespace argocd
#kubectl -n argocd apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install --namespace argocd --create-namespace argocd --values ./argocd-values.yaml argo/argo-cd 
#helm upgrade --install --namespace argocd --create-namespace argocd  --values ./argocd-values.yaml argo/argo-cd 
kubectl apply -f ./gitops-prj.yaml
kubectl apply -f ./gitops-cicd-app.yaml




