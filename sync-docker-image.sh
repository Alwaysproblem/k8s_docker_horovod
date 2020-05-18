#!/bin/bash

set -ex
# run on the n-adx-recall-2 server
docker save $1 > sync.tar
sudo mv sync.tar /data02/
ssh n-adx-recall-3 "docker load < /data02/sync.tar"
ssh n-adx-recall-4 "docker load < /data02/sync.tar"

sudo rm -rf /data02/sync.tar