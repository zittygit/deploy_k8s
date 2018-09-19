#!/bin/bash

get_images(){
# required master images for the version of choice
# k8s.gcr.io/kube-apiserver-${ARCH}	 	     v1.9.x
# k8s.gcr.io/kube-controller-manager-${ARCH} v1.9.x
# k8s.gcr.io/kube-scheduler-${ARCH}	         v1.9.x
# k8s.gcr.io/kube-proxy-${ARCH}	             v1.9.x
# k8s.gcr.io/etcd-${ARCH}	                 3.1.10
# k8s.gcr.io/pause-${ARCH}	                 3.0
# k8s.gcr.io/k8s-dns-sidecar-${ARCH}	     1.14.7
# k8s.gcr.io/k8s-dns-kube-dns-${ARCH}	     1.14.7
# k8s.gcr.io/k8s-dns-dnsmasq-nanny-${ARCH}	 1.14.7
# gcr.io/google_containers/etcd-amd64:3.1.11

# 注意：镜像应该从这个仓库拉取 gcr.io/google_containers/ 或者将tag改成该仓库

ARCH="amd64"
images=(
        kube-apiserver-${ARCH}:v1.9.9	 	    
        kube-controller-manager-${ARCH}:v1.9.9
        kube-scheduler-${ARCH}:v1.9.9 
        kube-proxy-${ARCH}:v1.9.9        
        etcd-${ARCH}:3.1.10	                
        pause-${ARCH}:3.0	                
        k8s-dns-sidecar-${ARCH}:1.14.7	    
        k8s-dns-kube-dns-${ARCH}:1.14.7		    
        k8s-dns-dnsmasq-nanny-${ARCH}:1.14.7	
)	

for image in ${images[@]}
  do
     docker pull k8s.gcr.io/${image}
	 name=${image//:/-}.tar
	 docker save -o ${name} k8s.gcr.io/${image}
  done
  # etcd
  docker pull gcr.io/google_containers/etcd-amd64:3.1.11
  docker save -o etcd-amd64-3.1.11.tar gcr.io/google_containers/etcd-amd64:3.1.11
  #flannel
  docker pull quay.io/coreos/flannel:v0.10.0-amd64
  docker save -o flannel-v0.10.0-amd64.tar quay.io/coreos/flannel:v0.10.0-amd64
}



get_kubeadm(){
#list version
#yum list kubeadm --disableexcludes=kubernetes --showduplicates
#download rpm
yum install -y kubelet-1.9.9-0 kubeadm-1.9.9-0 kubectl-1.9.9-0 --disableexcludes=kubernetes --downloadonly --downloaddir=/root/package/k8s
tar -zcvf k8s.tar.gz /root/package/k8s/

}
