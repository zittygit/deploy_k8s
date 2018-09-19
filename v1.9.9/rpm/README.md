
### 下载需要的rpm安装包
- 环境：CentOS 7 x86_64
- 命令：yum install --downloadonly 将rpm下载下来

#### 具体步骤
 - 添加[Kubernetes.repo](https://kubernetes.io/docs/setup/independent/install-kubeadm/)
```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF
setenforce 0
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable kubelet && systemctl start kubelet
```
- 查看 kubelet,kubeadm,kubectl版本
···
yum list kubeadm --disableexcludes=kubernetes --showduplicates
···
- 下载指定版本的rpm到指定的目录
···
yum install -y kubelet-1.9.9-0 kubeadm-1.9.9-0 kubectl-1.9.9-0 --disableexcludes=kubernetes --downloadonly --downloaddir=/root/package/k8s
#打包
tar -zcvf k8s.tar.gz /root/package/k8s/
····
