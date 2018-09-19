
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

#### 问题记录

- ERROR Swap
```
[ERROR Swap]: running with swap on is not supported. Please disable swap
```
1.9.x版本不支持swap需要关闭swap,解决方案有两种
1. 在/etc/systemd/system/kubelet.service.d/10-kubeadm.conf中添加Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false。在kubeadm init 添加参数--ignore-preflight-errors=Swap

```
sed -i '9s/^/Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"\n/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
```

2. 关闭系统swap

```
swapoff -a
```

---

- ERROR CRI

```
[ERROR CRI]: unable to check if the container runtime at "/var/run/dockershim.sock" is running: exit status 1`.
```

在kubeadm init 添加参数--ignore-preflight-errors=cri

---

- kubeapiserver无法连接
```
The connection to the server localhost:8080 was refused - did you specify the right host or port?
```
解决方法两种：
- 第一种适合root用户，不适合在shell脚本中执行，因为shell执行结束后环境变量就失效了
```
export KUBECONFIG=/etc/kubernetes/admin.conf
```
- 第二种适合非root用户，适合在shell脚本中执行
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

  
