docker run --privileged --rm -it --name hvd --network=host -v "/home/sdev/share/ssh:/root/.ssh/" alwaysproblem/adalgohvd /bin/bash -c "/usr/sbin/sshd -p 23445; sleep infinity"
docker run --privileged --rm -it --name hvd --network=host -v "/data02/hvd_share/ssh:/root/.ssh/" alwaysproblem/adalgohvd /bin/bash -c "/usr/sbin/sshd -p 23445; sleep infinity"
horovodrun --start-timeout 600 -np 16 -H n-adx-recall-2:8,n-adx-recall-3:8 -p 23445 python fashion.py
