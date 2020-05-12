# k8s_docker_horovod

some try for k8s + docker + horovod

## ssh configuration

if the user of your ssh public key is `root` make sure the ssh directory is owned by `root` and the group `root`, and the file permission of `authorized_keys` `id_rsa.pub` `known_hosts` should be `644` and `id_rsa` `600`

## ssh log in between pods

- use same id_rsa, id_rsa.pub and authorized_kyes or same authorize_kyes including same public keys between different pods

- start the minikube `minikube start --vm=hyperkit`

- enter directory `cd k8s_docker_horovod`

- mount disk to kyperkit `minikube mount --uid root --gid root --mode=384 $(pwd)/tmp:/home/tmp`

  1. comment: `uid` is the permission of hyperkit after mounting disk

  2. comment: `gid` is the permission of hyperkit after mounting disk

  3. comment: `mode` is need to conver int base 8(rwxr-xr-x 755) to int based 10 (493)

- apply the yaml files with kubectl

- enter a certain pod and ssh the other service IP and port.

## ssh channel

- ssh Local Port Forwarding

  ```bash
  ssh -L <local-host-port>:<taget-server-ip>:<target-port> <jumper-sever-ip-or-dns> -l <user-name>
  ```

## k8s custom columns output

[reference](https://kubernetes.io/docs/reference/kubectl/overview/#custom-columns)

- you need to check kubectl get pods <pod-name> -o yaml first for your selection.

- inline `kubectl get pods <pod-name> -o custom-columns=CUSTOM_COLUMN_NAME:.metadata.name,RSRC:.metadata.resourceVersion`

  ```yaml
  ...
  metadata:
    name: "submit-queue"
    resourceVersion: "610995"
  ...
  ```

  ```bash
  kubectl get pods <pod-name> -o custom-columns=NAME:.metadata.name,RSRC:.metadata.resourceVersion
  ```

- template file

  ```text
  NAME          RSRC
  metadata.name metadata.resourceVersion
  ```

  the result should be like:

  ```bash
  NAME           RSRC
  submit-queue   610995
  ```
