docker run --privileged --rm -it --name hvd --network=host -v "/home/sdev/share/ssh:/root/.ssh/" alwaysproblem/adalgohvd /bin/bash -c "/usr/sbin/sshd -p 23445; sleep infinity"
docker run --privileged --rm -it --name hvd --network=host -v "/data02/hvd_share/ssh:/root/.ssh/" alwaysproblem/adalgohvd /bin/bash -c "/usr/sbin/sshd -p 23445; sleep infinity"
horovodrun --start-timeout 600 -np 16 -H n-adx-recall-2:8,n-adx-recall-3:8 -p 23445 python fashion.py

horovodrun --start-timeout 600 -np 16 -H 10.110.160.33:8,10.105.200.71:8 -p 23445 python fashion.py

# test local:
horovodrun --start-timeout 600 -np 8 -H localhost:8 -p 23445 -x LD_LIBRARY_PATH python fashion.py
