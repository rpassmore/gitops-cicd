#!/bin/bash
kubectl create namespace argocd
kubectl -n argocd apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f ./gitops-prj.yaml
kubectl apply -f ./gitops-cicd-app.yaml
