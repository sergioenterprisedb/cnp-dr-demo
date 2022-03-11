#!/bin/bash

# Author      : Sergio Romera
# Created     : 10/03/2022
# Description : Install secrets

kubectl create secret generic aws-creds \
  --from-literal=ACCESS_KEY_ID=<access_key_id> \
  --from-literal=ACCESS_SECRET_KEY=<access_secret_key>

kubectl apply -f app-secret.yaml
kubectl apply -f superuser-secret.yaml

