# kubenetes-setup

## installation

```bash
apt-get update -y
# add ip host
swapoff -a

nano /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda4 during installation
UUID=6f612675-026a-4d52-9d02-547030ff8a7e /               ext4    errors=remount-ro 0       1
# swap was on /dev/sda6 during installation
#UUID=46ee415b-4afa-4134-9821-c4e4c275e264 none            swap    sw              0       0
/dev/sda5 /Data               ext4   defaults  0 0

# install Docker

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update -y
apt-get install kubelet kubeadm kubectl -y
kubeadm init  --pod-network-cidr=10.96.0.0/16 --apiserver-advertise-address=<machine IP>

```