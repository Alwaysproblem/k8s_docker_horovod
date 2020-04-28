set -ex
# TensorFlow version is tightly coupled to CUDA and cuDNN so it should be selected carefully
TENSORFLOW_VERSION=2.1.0

# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils
DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install --assume-yes --no-install-recommends apt-utils

apt-get install -y bzip2 libbz2-dev zlib1g-dev libssl-dev openssl libgdbm-dev \
    && apt-get install -y build-essential libsqlite3-dev sqlite3 \
    && apt-get install -y libgdbm-compat-dev liblzma-dev libreadline-dev \
    && apt-get install -y libncursesw5-dev libffi-dev uuid-dev

apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        cmake \
        g++-4.8 \
        git \
        curl \
        vim \
        nano \
        wget \
        ca-certificates \
        libjpeg-dev \
        libpng-dev \
        librdmacm1 \
        libibverbs1 \
        ibverbs-providers

rm -rf /var/lib/apt/lists/*
# RUN apt-get install -y wget gcc g++ && rm -rf /var/lib/apt/lists/*

# && apt-get install openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-deve -y \
mkdir /tmp/openmpi && \
    cd /tmp/openmpi && \
    wget https://www.open-mpi.org/software/ompi/v4.0/downloads/openmpi-4.0.0.tar.gz && \
    tar zxf openmpi-4.0.0.tar.gz && \
    cd openmpi-4.0.0 && \
    ./configure --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install && \
    ldconfig && \
    rm -rf /tmp/openmpi

#python3.7.6 pls compile with --with-ssl or you can not use pip3
cd /tmp \
    && tar -zvxf Python-3.7.6.tgz \
    && wget https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tgz \
    && cd Python-3.7.6 \
    && ./configure --enable-optimizations --with-ssl \
    && make install \
    && ln -sf /usr/local/bin/python3 /usr/bin/python \
    && ln -sf /usr/local/bin/pip3 /usr/bin/pip


# #python3
# RUN wget https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tgz
# RUN tar -zxvf Python-3.7.6.tgz
# RUN mv Python-3.7.6 /usr/local/
# RUN cd /usr/local/Python-3.7.6 && \
#     ./configure && \
#     make && \
#     make install &&\
#     mv /usr/bin/python /usr/bin/python.2 && \
#     ln -sf /usr/local/bin/python3 /usr/bin/python
 
#python3-pip
pip install --upgrade pip
 
#numpy setup
pip install --no-cache-dir tensorflow sklearn scipy pandas numpy

#horovod setup
HOROVOD_WITH_TENSORFLOW=1 \
    pip install --no-cache-dir horovod[tensorflow,keras]

# Install OpenSSH for MPI to communicate between containers
apt update && \
apt-get install -y --no-install-recommends openssh-client openssh-server && \
    mkdir -p /var/run/sshd
 
# Allow OpenSSH to talk to containers without asking for confirmation
cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
    mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

# Download examples
apt-get install -y --no-install-recommends subversion && \
    svn checkout https://github.com/horovod/horovod/trunk/examples && \
    rm -rf /examples/.svn