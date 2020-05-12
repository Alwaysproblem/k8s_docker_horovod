# for running without k8s
docker run --privileged --rm -it --name hvd --network=host -v "/home/sdev/share/ssh:/root/.ssh/" alwaysproblem/adalgohvd /bin/bash -c "/usr/sbin/sshd -p 23445; sleep infinity"
docker run --privileged --rm -it --name hvd --network=host -v "/data02/hvd_share/ssh:/root/.ssh/" alwaysproblem/adalgohvd /bin/bash -c "/usr/sbin/sshd -p 23445; sleep infinity"
horovodrun --start-timeout 600 -np 16 -H n-adx-recall-2:8,n-adx-recall-3:8 -p 23445 python fashion.py


# for k8s cmd
kubectl exec -it hvd-trainjob-0-69488dbbcc-tnjsx -- bash -c "horovodrun --start-timeout 600 -np 16 -H 10.102.194.37:8,10.97.64.43:8,10.102.129.212:8 -p 23445 python fashion.py"
horovodrun --start-timeout 600 -np 16 -H 10.102.194.37:8,10.97.64.43:8,10.102.129.212:8 -p 23445 python fashion.py

# test local:
horovodrun --start-timeout 600 -np 8 -H localhost:8 -p 23445 python fashion.py
