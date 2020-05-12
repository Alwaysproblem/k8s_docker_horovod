#!/usr/bin/bash

# delete training pods
kubectl delete -f trainhvd & 
kubectl delete -f trainhvd1 &
kubectl delete -f trainhvd2 &

# shut down tensorboard service
kubectl delete -f TFBoardService &

wait