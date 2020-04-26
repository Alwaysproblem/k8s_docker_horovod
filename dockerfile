FROM ubuntu:18.04

# RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --assume-yes --no-install-recommends apt-utils

RUN apt-get install -y bzip2 libbz2-dev zlib1g-dev libssl-dev openssl libgdbm-dev \ 
    && apt-get install -y build-essential libsqlite3-dev sqlite3 \ 
    && apt-get install -y libgdbm-compat-dev liblzma-dev libreadline-dev \
    && apt-get install -y libncursesw5-dev libffi-dev uuid-dev

RUN apt-get install -y wget gcc g++ && rm -rf /var/lib/apt/lists/*

# && apt-get install openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-deve -y \
RUN mkdir /tmp/openmpi && \
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
RUN cd /tmp \
    && wget https://www.python.org/ftp/python/3.7.6/Python-3.7.6.tgz \
    && tar -zvxf Python-3.7.6.tgz \
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
# RUN apt-get install libssl-dev -y
RUN pip install --upgrade pip
 
#numpy setup
RUN pip install tensorflow sklearn scipy pandas numpy

#horovod setup
RUN pip install --no-cache-dir horovod[tensorflow, keras]

RUN mkdir -p /yongxi/Desktop/project

WORKDIR /yongxi/Desktop/project

# Install OpenSSH for MPI to communicate between containers
RUN apt update
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && \
    mkdir -p /var/run/sshd
 
# Allow OpenSSH to talk to containers without asking for confirmation
RUN	cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
    mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config