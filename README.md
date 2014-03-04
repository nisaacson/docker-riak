docker-riak
===========

Builds a docker image for Riak.

```docker run -d nisaacson/riak```

# Building

To build a docker image, use the included Vagrantfile to launch up a virtual machine with docker already installed. The Vagrantfile uses the [vagrant docker provisioner](http://docs.vagrantup.com/v2/provisioning/docker.html) to install docker

**Requirements**

* [Vagrant](http://www.vagrantup.com/)

To launch the vagrant virtual machine

```bash
cd /path/to/this/repo
vagrant up --provision
```

Once the virtual machine is running it will have the Riak server already started within it

# Accessing Docker
```bash
# log into the virtual machine
vagrant ssh
# show a list of running images
docker ps
# to ensure that the image exists, you should see the `riak-client` image in the list output
docker images

# connect to the riak service running in the container via riak http interface
curl "http://localhost:8098"

# You can connect to the running container via the mapped ssh port
ssh -p 2222 root@localhost
# password: basho
```

# Notes

* Backend: The riak container is configured to use the [leveldb backend](http://docs.basho.com/riak/latest/ops/advanced/backends/leveldb/).
* Search: The riak container is configured with [search enabled](http://docs.basho.com/riak/latest/ops/advanced/configs/search/)

To use search, you must first enable it on a bucket before adding any data. [How to enable Search](http://docs.basho.com/riak/1.4.0/cookbooks/Riak-Search---Indexing-and-Querying-Riak-KV-Data/)

Underscore.js is available by default for use in map-reduce javascript functions.
