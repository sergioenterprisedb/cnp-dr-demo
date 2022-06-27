#!/bin/bash

# Docker client
#hostname=`hostname`
#docker run --name my-mc --hostname my-mc -e hostname=`hostname` -it --entrypoint /bin/bash --rm minio/mc

# Create bucket
mc alias set myminio/ http://${hostname}:9000 admin password
mc mb myminio/cnp
#mc admin user add myminio sergio password
#mc ls myminio/cnp
#mc rb myminio/cnp --force
