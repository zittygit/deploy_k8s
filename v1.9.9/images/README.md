
#### 获取k8s离线部署所需要的镜像
该脚本能自动pull该版本k8s所需所有镜像，并将镜像打包成tar文件。

- 环境
  - k8s v1.9.9
  - CentOS 7 x86_64
  
- 脚本需要在能访问google的环境中运行。
- 脚本执行流程
  - pull 镜像
  - tag 新的镜像库，新的镜像根据k8s中的manifest目中的yml文件可以找到。
  - save 将镜像打包成tar文件
  
- Note:该目前仅存放镜像，deploy.sh脚本默认该文件夹中所有文件当成image文件load到docker中。
