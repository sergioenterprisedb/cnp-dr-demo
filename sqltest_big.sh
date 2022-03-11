#!/bin/bash

# Author      : Sergio Romera
# Created     : 10/03/2022
# Description : Create and insert lines in table

. ./config_cnp.sh

kubectl exec -it ${cluster_name}-1 -- psql -c "DROP TABLE IF EXISTS t_test"
sleep 1
kubectl exec -it ${cluster_name}-1 -- psql -c "CREATE TABLE t_test (id serial, name text)"
sleep 1
kubectl exec -it ${cluster_name}-1 -- psql -c "INSERT INTO t_test (name) SELECT 'sergio' FROM generate_series(1, 2000000)"
