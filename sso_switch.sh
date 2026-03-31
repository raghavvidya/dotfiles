#!/bin/bash

profiles=($(aws-sso|egrep 'dev|test|prod'|grep -i admin|grep -v qs-admin|sort -k3,3|awk -F"|" '{print $4}'))

echo "Select a profile:"
select ctx in "${profiles[@]}"; do
  if [ -n "$ctx" ]; then
    aws-sso exec --profile "$ctx"
    break
  else
    echo "Invalid selection"
  fi
done
