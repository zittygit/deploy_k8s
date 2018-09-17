#!/bin/bash

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

