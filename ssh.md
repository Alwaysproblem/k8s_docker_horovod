# ssh log in between pods

- use same id_rsa, id_rsa.pub and authorized_kyes or same authorize_kyes including same public keys between different pods

- start the minikube `minikube start --vm=hyperkit`

- enter directory `cd k8s_docker_horovod`

- mount disk to kyperkit `minikube mount --uid root --gid root --mode=384 $(pwd)/tmp:/home/tmp`
    - comment: `uid` is the permission of hyperkit after mounting disk
    - comment: `gid` is the permission of hyperkit after mounting disk
    - comment: `mode` is need to conver int base 8(rwxr-xr-x 755) to int based 10 (493)

- apply the yaml files with kubectl

- enter a certain pod and ssh the other service IP and port.

