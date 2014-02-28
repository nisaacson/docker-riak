#!/usr/bin/env bash


echo "----> Run riak container"

# Port forwarding
HOST_SSH_PORT=2222
CONTAINER_SSH_PORT=22

HOST_PROTO_BUF=8087
CONTAINER_PROTO_BUF=8087

HOST_HTTP_PORT=8098
CONTAINER_HTTP_PORT=8098

IMAGE="riak-client"
NAME="riak"

function stop_container {
  echo "-----> Stop container $NAME"
  docker kill $NAME 1>/dev/null 2>/dev/null || true
  docker rm $NAME   1>/dev/null 2>/dev/null || true
  echo "       $NAME stopped"
}

function start_container {
  command="docker run                       \
    -name $NAME                             \
    -p $HOST_SSH_PORT:$CONTAINER_SSH_PORT   \
    -p $HOST_PROTO_BUF:$CONTAINER_PROTO_BUF \
    -p $HOST_HTTP_PORT:$CONTAINER_HTTP_PORT \
    -d $IMAGE"
  ID=$($command)
  echo "      riak container running with id $ID"
}

function wait_for_riak {
  echo "-----> wait for riak to come online"
  DATA="this is a test"
  KEY="foo"
  RIAK_URL="http://127.0.0.1:8098/buckets/test/keys/$KEY"

  while true
  do
    curl --silent -X PUT $RIAK_URL -H "Content-Type: text/plain" -d "$DATA"
    RESPONSE=$(curl --silent $RIAK_URL)
    echo "create row response $RESPONSE"
    if [[ $RESPONSE == $DATA ]]; then
      echo "       riak server online"
      curl --silent -X DELETE $RIAK_URL
      return
    fi
    sleep "2s"
  done
}

stop_container
start_container
wait_for_riak
