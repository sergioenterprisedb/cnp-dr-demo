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
  instances=`grep instances ${cluster_file} | awk '{print $2}' | cut -c1`
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

#Install CNP
start=$SECONDS

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
sleep 5

echo "***********************"
echo "*** Install cluster ***"
echo "***********************"
msg "kubectl apply -f ${cluster_file}"
kubectl apply -f ${cluster_file}
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

