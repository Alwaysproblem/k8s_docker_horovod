#!/usr/bin/bash

# start train pods and waiting
kubectl apply -f trainhvd & 
kubectl apply -f trainhvd1 &
kubectl apply -f trainhvd2 &

# start tensorboard sevice on the path "nfs:///data02/training/tensorboard/logs"
kubectl apply -f TFBoardService &

wait