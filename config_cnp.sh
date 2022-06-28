#!/bin/bash

# Author      : Sergio Romera
# Created     : 10/03/2022
# Description : Config file

export version=`kubectl cnp version | awk '{ print $2 }' | awk -F":" '{ print $2}'`
export plugging="https://github.com/EnterpriseDB/kubectl-cnp/raw/main/install.sh"
export operator="https://get.enterprisedb.io/cnp/postgresql-operator-${version}.yaml"
export cluster_file1="cluster1.yaml"
export cluster_file2="cluster2.yaml"
export cluster_name="cluster1"
export S3_MINIO_DIRECTORY="./S3_MINIO"
export S3_AWS_DIRECTORY="./S3_AWS"
# MINIO or AWS
export OBJECT_STORAGE="MINIO"
export IMAGENAME="quay.io/enterprisedb/postgresql:14.1"
# AWS S3
export S3_DESTINATIONPATH="s3://sergiocnp/cnp/dr"
export s3_cluster1="s3://sergiocnp/cnp/dr/cluster1"
export s3_cluster2="s3://sergiocnp/cnp/dr/cluster2"

# MinIO config
export HOSTNAME=$(ifconfig -a|grep 192|head -n1|awk '{print $2}')
export MINIO_DESTINATIONPATH="s3://cnp/"
export MINIO_PORT=9000
export MINIO_ENDPOINTURL="http://${HOSTNAME}:${MINIO_PORT}"

# **************
# *** Colors ***
# **************
c_r="\e[0m" #reset color
c_green="\e[32m"
c_red="\e[31m"
c_default="\e[39m"
