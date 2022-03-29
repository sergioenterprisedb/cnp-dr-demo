#!/bin/bash

# Author      : Sergio Romera
# Created     : 10/03/2022
# Description : Install secrets

kubectl create secret generic aws-creds \
  --from-literal=ACCESS_KEY_ID=<access_key_id> \
  --from-literal=ACCESS_SECRET_KEY=<access_secret_key> \
  --from-literal=ACCESS_SESSION_TOKEN=<token>

kubectl apply -f app-secret.yaml
kubectl apply -f superuser-secret.yaml
kubectl create secret generic minio-creds \
  --from-literal=MINIO_ACCESS_KEY=admin \
  --from-literal=MINIO_SECRET_KEY=password

