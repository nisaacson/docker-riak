docker-riak
===========

Builds a docker image for Riak.

```docker run -d jplock/riak```

# Building

To build a docker image, use the included Vagrantfile to launch up a virtual machine with docker already installed. The Vagrantfile uses the [vagrant docker provisioner](http://docs.vagrantup.com/v2/provisioning/docker.html) to install docker

**Requirements**

* [Vagrant](http://www.vagrantup.com/)

To launch the vagrant virtual machine

```bash
cd /path/to/this/repo
vagrant up
```

Once the virtual machine is running you can test out the `Dockerfile` via

```bash
# log into the virtual machine
vagrant ssh
# go to the mounted shared folder
cd /vagrant

# build a docker image from the Dockerfile
docker build -t riak .

# ensure that the image exists, you should see the `riak` image in the list output
docker images

# run the container, mapping ports on the host virtual machine to the same ports inside the container
ID=$(docker run -d -p 8087:8087 -p 8098:809 riak)

# wait a few seconds and then check the logs on the container, you should see the output from riak starting up.
docker logs $ID

# connect to the riak service running in the container via riak http interface
curl "http://localhost:8098"
```

# Notes

* Backend: The riak container is configured to use the [leveldb backend](http://docs.basho.com/riak/latest/ops/advanced/backends/leveldb/).
* Search: The riak container is configured with [search enabled](http://docs.basho.com/riak/latest/ops/advanced/configs/search/)

To use search, you must first enable it on a bucket before adding any data. [How to enable Search](http://docs.basho.com/riak/1.4.0/cookbooks/Riak-Search---Indexing-and-Querying-Riak-KV-Data/)
