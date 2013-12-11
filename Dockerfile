# DOCKER-VERSION 0.7.1
# VERSION        0.4

FROM ubuntu
MAINTAINER Justin Plock <jplock@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get -y -q install curl

# Hack for initctl not being available in Ubuntu
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

RUN curl http://apt.basho.com/gpg/basho.apt.key | apt-key add -
RUN echo "deb http://apt.basho.com precise main" > /etc/apt/sources.list.d/basho.list
RUN apt-get update
RUN apt-get -y -q install riak || true
# bind to all interfaces
RUN sed 's/127.0.0.1/0.0.0.0/' -i /etc/riak/app.config

# switch to leveldb as the riak backend
RUN sed -i -e s/riak_kv_bitcask_backend/riak_kv_eleveldb_backend/g app.config
# enable search. the sed command below only replaces the first line it matches
RUN sed -i -e 0,/"enabled, false"/{s/"enabled, false"/"enabled, true"/} app.config

# Expose http port and protocol buffer port
EXPOSE 8098 8087

# change ulimit as suggested by riak start command, then start riak
CMD ulimit -n 4096 && /usr/sbin/riak start && tail -f /var/log/riak/console.log
