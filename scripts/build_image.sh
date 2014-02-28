#!/usr/bin/env bash
echo "-----> Build docker image"
cd /vagrant/project && docker build -t riak-client .
if [[ $? -ne 0 ]]; then
  echo "      failed to build docker image" >&2
  exit 1
fi
echo "       done building docker image"
