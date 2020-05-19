# run horovod program on k8s

## basic idea

- build multiple deployment with service (service is not changed when restarting pods).
- make sure that they can login through ssh with each other (using the same authorized_keys file and public keys file).
- lauch training on one of those pods.

## run example

- procedure

    ```bash
    bash start-dep.sh
    kubectl get all -o wide # view all the IP address for services
    kubectl exec -it <pods id> -- bash - c "horovodrun -np 3 <substitute host1 for IP address>:2,<substitute host2 for IP address>:2,<substitute host3 for IP address>:2 -p 23445 python fashion.py"
    ```
