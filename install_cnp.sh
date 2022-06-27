#!/bin/bash

# Author      : Sergio Romera
# Created     : 10/03/2022
# Description : Install CNP cluster

. ./config_cnp.sh

function check_deployment()
{
  status=0
  sp="/-\|"

  while [ $status -ne 1 ]
  do
    printf "\b${sp:i++%${#sp}:1}"
    status=`kubectl get deploy -n postgresql-operator-system postgresql-operator-controller-manager | sed -n 2p | awk '{print $4}'`
    sleep 1 
  done

  printf "\b"
  msg "kubectl get deploy -n postgresql-operator-system postgresql-operator-controller-manager"
  kubectl get deploy -n postgresql-operator-system postgresql-operator-controller-manager

}

function check_cluster()
{
  status=0
  counter=1
  instances=0
  instances=`grep instances ${cluster_file1} | awk '{print $2}' | cut -c1`
  sp="/-\|"
    
  #sleep 5
  #msg "kubectl cnp status ${cluster_name}"

  while [ $status -ne $instances ]
  do
    sleep 1

    status=`echo $status | xargs`
    printf "\rNumber of pods created: $status ${sp:i++%${#sp}:1}"
    #"^[[32m3^[[0m"
    if [ `expr $counter % 5` -eq 0 ]; then
      status=`kubectl cnp status ${cluster_name} | grep 'Ready' | awk '{print $3}' | cut -c6`
      if [ -z "$status" ]; then
        status=0
      fi
      #status=${status:5:1}
      #echo "yes"
    fi
    (( counter++ ))

  done

  status=`echo $status | xargs`
  printf "\b\rNumber of pods created: $status"
  printf "\n"

}

function install_plugin()
{
  msg "curl -sSfL ${plugging} | sh -s -- -b /usr/local/bin"
  curl -sSfL ${plugging} | sh -s -- -b /usr/local/bin
}

function install_cnp_operator()
{
  msg "kubectl apply -f ${operator}"
  kubectl apply -f ${operator}
  sleep 2
}

function msg()
{
  printf "${c_green}$1${c_r}\n"
}

function install_minio_client() 
{
  if [ "${OBJECT_STORAGE}" == "MINIO" ]; then
    #cat install_minio_docker_client.sh | \
    #docker run --name my-mc --hostname my-mc -e hostname=`hostname` -i --entrypoint /bin/bash --rm minio/mc
    if [ `ps -edf | grep minio/minio | grep -v grep | wc -l` -eq 0 ]; then
      printf "/!\ MINIO not started\n"
      printf "Please, start MINIO (start_minio_docker_server.sh) and execute again\n"
      exit
    fi
  fi
}

function object_storage_config ()
{
  if [ ${OBJECT_STORAGE} == "MINIO" ]; then
    echo "MinIO config"
    install_minio_client
    cp ${S3_MINIO_DIRECTORY}/*.yaml .
  fi

  if [ ${OBJECT_STORAGE} == "AWS" ]; then
    echo "AWS S3 config"
    cp ${S3_AWS_DIRECTORY}/*.yaml .
  fi
}

function replace_config()
{
  # MINIO
  sed -i -e "s|###IMAGENAME###|${IMAGENAME}|g" cluster*.yaml
  sed -i -e "s|###MINIO_DESTINATIONPATH###|${MINIO_DESTINATIONPATH}|g" cluster*.yaml
  sed -i -e "s|###MINIO_ENDPOINTURL###|${MINIO_ENDPOINTURL}|g" cluster*.yaml

  #S3
  sed -i -e "s|###IMAGENAME###|${IMAGENAME}|g" cluster*.yaml
  sed -i -e "s|###S3_DESTINATIONPATH###|${S3_DESTINATIONPATH}|g" cluster*.yaml

}

#Install CNP
start=$SECONDS

echo "********************************"
echo "*** Configure Object Storage ***"
echo "********************************"
object_storage_config

echo "*******************************"
echo "*** Installing CNP Plugging ***"
echo "*******************************"
install_plugin

echo "*******************************"
echo "*** Installing CNP Operator ***"
echo "*******************************"
install_cnp_operator

echo "***********************************"
echo "*** Verify install CNP Operator ***"
echo "***********************************"
check_deployment

echo "***************************"
echo "*** Install secrets AWS ***"
echo "***************************"
. ./install_secrets.sh
sleep 2

echo "**********************"
echo "*** Replace config ***"
echo "**********************"
replace_config

echo "***********************"
echo "*** Install cluster ***"
echo "***********************"
msg "kubectl apply -f ${cluster_file1}"
kubectl apply -f ${cluster_file1}
check_cluster

echo "***************************"
echo "*** Show cluster status ***"
echo "***************************"
kubectl cnp status ${cluster_name}

end=$SECONDS
echo "Duration: "
echo "***********************************************"
echo "*** Installation successfully in $((end-start)) seconds ***"
echo "***********************************************"
echo "Execute this command to check the cluster status:"
echo ""
msg "kubectl cnp status ${cluster_name}"
echo ""

# curl -sSfL https://github.com/EnterpriseDB/kubectl-cnp/raw/main/install.sh | sh -s -- -b /usr/local/bin
# kubectl apply -f https://get.enterprisedb.io/cnp/postgresql-operator-1.14.0.yaml
# kubectl get deploy -n postgresql-operator-system postgresql-operator-controller-manager
# kubectl apply -f cluster1.yaml

