
## offline automatic deployment k8s

#### 部署环境
- CentOs 7 X86_64
- k8s v1.9.9
- docker v1.13.1 

#### 安装包和镜像准备
离线安装需要翻墙将需要的镜像和rpm安装包下载准备好，下面就介绍如何下载需要的镜像和rpm安装包。

- 镜像
  - [x] kube-apiserver-amd64                  
  - [x] kube-controller-manager-amd64    
  - [x] kube-scheduler-amd64	          
  - [x] kube-proxy-amd64	             
  - [x] etcd-amd64	                     
  - [x] pause-amd64	                        
  - [x] k8s-dns-sidecar-amd64	              
  - [x] k8s-dns-kube-dns-amd64	    
  - [x] k8s-dns-dnsmasq-nanny-amd64          
  - [x] etcd-amd64
  - [x] flannel
  
**Note:** *镜像的镜像库名称需要正确，具体镜像库在/etc/kubernetes/manifests目录中的yml文件中可以查看。get_images代码已完善。*

- rpm安装包
  - [x] docker
  - [x] kubeadm
  - [x] kubelet
  - [x] kubectl
 
#### 结构介绍
- images 目录仅存储镜像
- k8s 目录存储yml文件
- rpm 目录存储rpm安装包

#### 部署命令

```
sh deploy.sh
```

  
