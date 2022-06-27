#!/bin/bash

# Author      : Sergio Romera
# Created     : 10/03/2022
# Description : Delete cluster1

. ./config_cnp.sh

# Delete yamls
kubectl delete -f cluster1.yaml
kubectl delete -f backup_cluster1.yaml

# AWS delete
if [ "${OBJECT_STORAGE}" == "AWS" ]; then
  aws s3 rm --recursive ${s3_cluster1}
else
  # Stop MinIO
  docker ps | grep minio | awk '{print $1}' | xargs -I % docker stop %
fi
