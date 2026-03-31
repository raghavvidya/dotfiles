#!/bin/bash

contexts=($(kubectl config get-contexts -o name))

echo "Select a context:"
select ctx in "${contexts[@]}"; do
  if [ -n "$ctx" ]; then
    kubectl config use-context "$ctx"
    break
  else
    echo "Invalid selection"
  fi
done
