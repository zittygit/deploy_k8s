#!/bin/bash

#k8s offline install script.
#k8s version 1.9.9 
#OS centos7

set -e

init_env(){
#close firewall
  systemctl stop firewalld && systemctl disable firewalld
  setenforce 0
  iptables -P FORWARD ACCEPT
  # close swap
  #swapoff -a && sysctl -w vm.swappiness=0
}

load_images(){
  for image in `ls images $1`
  do
     docker load < images/${image}
  done
  
  #change 'k8s.gcr.io' tag to 'gcr.io/google_containers' tag
  for tag in `docker images | awk '{print $1":"$2}'`
  do
    if [[ ${tag} =~ 'k8s.gcr.io' ]]
	then
	   new_tag=${tag/'k8s.gcr.io'/'gcr.io/google_containers'}
	   docker tag ${tag} ${new_tag}
	   docker rmi ${tag}
	fi
  done
}

install_docker(){
  tar zxf rpm/docker_v1.13.1.tar.gz -C /tmp
  yum localinstall -y /tmp/docker_v1.13.1/*.rpm 
  #sed -i -e 's/cgroupdriver=systemd/cgroupdriver=cgroupfs/g' /usr/lib/systemd/system/docker.service 
  #systemctl daemon-reload 
  systemctl enable docker   
  if systemctl start docker ; then
    rm -rf /tmp/docker_v1.13.1
  else
     #if SELinux is not supported with the overlay2 graph driver on this kernel then close selinux in docker
     sed -i -e 's/selinux-enabled/selinux-enabled=false/g' /etc/sysconfig/docker
	 systemctl start docker
  fi
  echo "docker install finish"
  
}

install_kubeadm(){
#Some users on RHEL/CentOS 7 have reported issues with traffic being routed incorrectly due to iptables being bypassed
  cat <<EOF>  /etc/sysctl.d/k8s.conf
  net.bridge.bridge-nf-call-ip6tables = 1
  net.bridge.bridge-nf-call-iptables = 1
EOF
  sysctl --system
  tar zxf rpm/k8s.tar.gz -C /tmp
  yum localinstall -y /tmp/k8s/*.rpm
  #swap need to close
  sed -i '9s/^/Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"\n/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
  systemctl daemon-reload
  systemctl enable kubelet && systemctl start kubelet
  #echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bashrc
  #source ~/.bashrc
  mkdir -p $HOME/.kube
  cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  chown $(id -u):$(id -g) $HOME/.kube/config
  kubeadm init --kubernetes-version=v1.9.9 --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=cri --ignore-preflight-errors=Swap
  #using journalctl -f -u kubelet.service to see what happening
  #for a single-machine Kubernetes cluster for development
  kubectl taint nodes --all node-role.kubernetes.io/master-
  kubectl apply -f k8s/kube-flannel.yml
  kubectl apply -f k8s/kubernetes-dashboard.yaml
  echo "kubeadm install finish"
}

main(){
  init_env
  install_docker
  load_images
  install_kubeadm
}

main