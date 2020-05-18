#!/bin/bash

docker image build -t $1 . -f $2 
# docker build - < files