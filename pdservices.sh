#!/bin/bash

set -e

if [[ $2 == start ]]; then
  do
    oc -n "$1-localcluster" --context minikube scale deployment --replicas 1 --all
  done
elif [[ $2 == stop ]]; then
  do
    oc -n "$1-localcluster" --context minikube scale deployment --replicas 0 --all
  done
else
  echo "Must be start or stop"
fi
