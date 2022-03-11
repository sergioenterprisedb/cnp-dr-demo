#!/bin/bash

# Author      : Sergio Romera
# Created     : 10/03/2022
# Description : Config file

export plugging="https://github.com/EnterpriseDB/kubectl-cnp/raw/main/install.sh"
export operator="https://get.enterprisedb.io/cnp/postgresql-operator-1.13.0.yaml"
export cluster_file="cluster1.yaml"
export cluster_name="cluster1"
export s3_cluster1="s3://sergiotest/cnp/dr/cluster1"
export s3_cluster2="s3://sergiotest/cnp/dr/cluster2"

# **************
# *** Colors ***
# **************
c_r="\e[0m" #reset color
c_green="\e[32m"
c_red="\e[31m"
c_default="\e[39m"
