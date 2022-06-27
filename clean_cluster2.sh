#!/bin/bash

# Author      : Sergio Romera
# Created     : 10/03/2022
# Description : Delete cluster2

. ./config_cnp.sh

# Delete yamls
kubectl delete -f cluster2.yaml
kubectl delete -f backup_cluster2.yaml

# AWS delete
aws s3 rm --recursive ${s3_cluster2}

