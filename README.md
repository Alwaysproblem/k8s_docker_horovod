# k8s_docker_horovod
some try for k8s + docker + horovod

## ssh configuration

if the user of your ssh public key is root make sure
the ssh directory is owned by root and the group root, 
and the file permission of authorized_keys id_rsa.pub
known_hosts should be 644 and id_rsa 600