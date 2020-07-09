# k8s 概念

## 术语

1. 常用资源类型 (缩写)
  - Pod (po, pods)
  - Replica (rs)
  - service (svc)
  - Deployment (deploy)
  - CustomResourceDefinition (crd)
  - statefulset
  - Job
  - CronJob

2. 授权
  - Clusterrolebinding
  - rolebinding
  - role
  - clusterrole

3. 集群本身常用资源
  - node 
  - namespaces (ns)

4. 配置文件资源
  - configMap (cm)
  - ServiceAccount (sa)
  - secret

5. 卷
  - Volume
  - PersistantVolumn (pv)
  - PersistantVolumneClaim (pvc)
  - StorageClass (sc)

## 整体资源概况

整个基本资源管理如下

```
    Deployment
        | 管理
      replica
        | 管理
       pod
        | 管理
      docker
```

```
/------------------\
| deployment        |
|  /---------------|
|  | replica       |
|  |  /------------|
|  |  | pod        |
|  |  |  /---------|
|  |  |  | docker  |
|  |  |  |         |
\------------------/
```

由于 k8s 有着自愈能力 也就是说 如果 有资源挂掉 将会自动重启
例如：
  如果 replica 发生错误 deployment 将重新生成一个 replica
  如果 pod 挂了 replica 会重启 pod
  如果 docker 容器挂了 pod 会重启 docker
  而且 每一个资源（除了Docker）都会有版本控制（可以回滚）
  
- POD：
  - 在Pod中 docker容器 可以访问Pod 的所有资源 pod 的ip 就是 docker 的 ip
  - Pod 一般都是 一个容器 也可以是 多个容器 多个容器的话 共享IP 和 端口
  - docker 挂掉后 pod 会重启 docker， 但如果 pod 只有 一个 docker 那么 pod 则会重启 这样的话pod的IP 所以可以 让一个小型的 `pause` 容器占位置 docker 挂掉后就不会重启pod 这样 也就不会重置 pod 的IP
  - log 打印 `kubectl logs <pod> -n <namespaces>`
  - pod 启动描述 `kubectl describe <pod> -n <namespace>`
  - k8s 调度 是以 POD 为单元
  - Pod 的生命周期结束后 会清除容器内的数据

- service
  - service 的IP 是不会 发生变化的 除非重启 Service

- Deployment
  - 一般看来说 部署应用程序 都用Deployment （这也是官方推荐的）

- CustomResourceDefinition (crd)
  - 自定义资源 一般可以管理 Deployment 也可以定义复杂的行为 例如： tf-operator 就是自定义资源

- statefulset
  - 一般用于有状态的程序 例如 数据读写程序 （有锁的状态）

- Job
  - Job 和 Deployment 差不多 但是 区别是 它是 一次性的 运行成功后就结束

- CronJob
  - CronJob 是定时任务 和 Job 差不多

- Clusterrolebinding （现在还在探究）

- rolebinding （现在还在探究）

- role （现在还在探究）

- clusterrole （现在还在探究）

- node
  - 这个就是 集群节点 代指 物理机

- namespaces (ns)
  - 命名空间 相当于 隔离不同的程序 也就是 程序的运行空间

- configMap (cm)
  - cm 是为了避免过多的修改yaml文件的配置所设置的 可以在 yaml 中调用，好处是 热重载 也就是说 程序在运行中改变cm 就会改变程序的配置

- ServiceAccount (sa)
  - sa 是为了方便k8s管理员自动授权的一个账户声明 （用户名）

- secret
  - 和 sa 配合使用 相当于 （密码）

- Volume
  - Volume 相当于 docker 的挂载将外部的路径直接挂载到POD上 （无法声明大小）

- PersistantVolumn (pv)
  - pv 相当于 管理员给你分出的一块硬盘 程序结束时 数据还在

- PersistantVolumneClaim (pvc)
  - pvc 相当于 你自己的程序需要一个多大的硬盘的一个声明（告诉管理员你要多大） 然后 k8s 根据你的 pvc 去寻找相匹配的 pv

- StorageClass (sc)
  - 一般来说 pv 是手动创建的， sc 是管理员预先定义的，定义好sc 之后 k8s 会根据 sc 自动生成pv 方便 管理员管理

## yaml 文件 结构

```yaml
apiVersion: v1
metadata:
  <something important>
spec:
  <something important>
## 以下是集群返回的状态参数 不用手写 自动生成
status:
  <something important>
```

样例：

TensorBoard Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tensorboard-deployment
spec:
  selector:
    matchLabels:
      app: tb-image
  replicas: 2
  template:
    metadata:
      labels:
        app: tb-image
    spec:
      containers:
      - name: tb-image
        image: tensorflow/tensorflow
        command: ["/bin/bash","-c"]
        args:
          - "tensorboard --logdir /tmp/logs --bind_all"
        volumeMounts:
        - mountPath: "/tmp/logs"
          name: tb-logs
        resources:
          limits:
            memory: "4Gi"
            cpu: "4"
        ports:
        - containerPort: 6006
      volumes:
        - name: tb-logs
          persistentVolumeClaim:
            claimName: tensorboard-pvc
      # restartPolicy: OnFailure

```

TensorBoard Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: tensorboard-service
spec:
  selector:
    app: tb-image
  type: NodePort
  # clusterIP: 10.0.171.239
  ports:
    - name: tensorboard
      protocol: TCP
      nodePort: 30022
      port: 6006
      targetPort: 6006
```

TensorBoard pvc

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: tensorboard-pvc
spec:
  accessModes:
    - ReadOnlyMany
  volumeMode: Filesystem
  resources:
    requests:
      storage: 500Mi
  storageClassName: s3fs
  selector:
    matchLabels:
      type: s3fs-storage
      app: tensorboard
```

Tensorboard pv

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: tensorboard-pv
  labels:
    type: s3fs-storage
    app: tensorboard
spec:
  storageClassName: s3fs
  capacity:
    storage: 500Mi
  accessModes:
    - ReadOnlyMany
  hostPath:
    path: "/home/sdev/s3mount/yongxi/TBlogs"
```

## label 标签

- label 是很重要的 他可以表明一个资源的身份
- selector 是可以选择 label条件的 pod 进行绑定

  例如：
    service 需要绑定 POD 进行服务则 需要在 services中声明 pod 的 label 作为条件 去筛选 符合label 条件的 Pod 进行绑定

## annotation 注释

- 虽然名字是注释 可是 有些注释 会改变 你的程序配置 例如 `storageclass.kubernetes.io/is-default-class: "true"` 这句话 将让你的 sc 变成 默认的 sc