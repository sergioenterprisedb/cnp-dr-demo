#!/bin/bash

# Author      : Sergio Romera
# Created     : 10/03/2022
# Description : Config file

export plugging="https://github.com/EnterpriseDB/kubectl-cnp/raw/main/install.sh"
export operator="https://get.enterprisedb.io/cnp/postgresql-operator-1.14.0.yaml"
export cluster_file1="cluster1.yaml"
export cluster_file2="cluster2.yaml"
export cluster_name="cluster1"
export S3_MINIO_DIRECTORY="./S3_MINIO"
export S3_AWS_DIRECTORY="./S3_AWS"
export OBJECT_STORAGE="MINIO"    # MINIO or AWS

# AWS S3
export s3_cluster="s3://sergiocnp/cnp/dr"
export s3_cluster1="s3://sergiocnp/cnp/dr/cluster1"
export s3_cluster2="s3://sergiocnp/cnp/dr/cluster2"

# MinIO config
export minio_destinationpath="s3://cnp/"
export minio_endpointURL="http://192.168.56.1:9000"

# **************
# *** Colors ***
# **************
c_r="\e[0m" #reset color
c_green="\e[32m"
c_red="\e[31m"
c_default="\e[39m"
