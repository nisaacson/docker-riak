# Riak
#
# VERSION       0.1.0
# Based off https://github.com/hectcastro/docker-riak
# Use the Ubuntu base image provided by dotCloud
FROM ubuntu:latest
MAINTAINER Noah Isaacson clewfirst+docker@gmail.com

# Update the APT cache
RUN sed -i.bak 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get update

# Install and setup project dependencies
RUN apt-get install -y curl lsb-release supervisor openssh-server
RUN apt-get install -y vim

RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

RUN locale-gen en_US en_US.UTF-8

ADD ./etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN echo 'root:basho' | chpasswd

# Permit root login and disable PAM and privilege separation configuration
RUN sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

# Add Basho's APT repository
ADD basho.apt.key /tmp/basho.apt.key
RUN apt-key add /tmp/basho.apt.key
RUN rm /tmp/basho.apt.key
RUN echo "deb http://apt.basho.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/basho.list
RUN apt-get update

# Install Riak and prepare it to run
RUN apt-get install -y riak
ADD ./etc/app.config /etc/riak/app.config

# Add external libraries
RUN mkdir -p /tmp/js_source
ADD ./etc/underscore.js /tmp/js_source/underscore.js


# switch to leveldb as the riak backend
RUN sed -i -e s/riak_kv_bitcask_backend/riak_kv_eleveldb_backend/g /etc/riak/app.config
# enable search. the sed command below only replaces the first line it matches
RUN sed -i -e 0,/"enabled, false"/{s/"enabled, false"/"enabled, true"/} /etc/riak/app.config

RUN echo "ulimit -n 4096" >> /etc/default/riak

ENV RIAK_NODE_NAME "127.0.0.1"
# Expose Protocol Buffers and HTTP interfaces
EXPOSE 8087 8098 22

CMD ["/usr/bin/supervisord"]
