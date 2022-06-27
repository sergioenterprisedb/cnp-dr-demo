#!/bin/bash

# Author      : Sergio Romera
# Created     : 10/03/2022
# Description : Delete cluster1

. ./config_cnp.sh

# Delete yamls
kubectl delete -f cluster1.yaml
kubectl delete -f cluster2.yaml
kubectl delete -f backup_cluster1.yaml
kubectl delete -f backup_cluster2.yaml
kubectl delete -f app-secret.yaml
kubectl delete -f superuser-secret.yaml
kubectl delete secret aws-creds
kubectl delete secret minio-creds


if [ "${OBJECT_STORAGE}" == "MINIO" ]; then
 # Docker
  # Remove minio bucket
  #cat remove_minio_bucket.sh | \
  #docker run --name my-mc --hostname my-mc -e hostname=`hostname` -i --entrypoint /bin/bash --rm minio/mc

  docker rmi -f minio/minio
  #docker rmi -f minio/mc

  # Stop MinIO
  docker ps | grep minio | awk '{print $1}' | xargs -I % docker stop %
fi

# AWS delete
if [ "${OBJECT_STORAGE}" == "AWS" ]; then
  aws s3 rm --recursive ${s3_cluster1}
  aws s3 rm --recursive ${s3_cluster2}
fi

