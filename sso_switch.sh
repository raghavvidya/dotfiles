#!/bin/bash

clear_aws_env() {
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
  unset AWS_PROFILE
  unset AWS_DEFAULT_PROFILE
}

profiles=($(aws-sso | egrep 'dev|test|prod' | grep -i admin | grep -v qs-admin | sort -k3,3 | awk -F"|" '{print $4}'))

echo "Select a profile:"
select ctx in "${profiles[@]}"; do
  if [ -n "$ctx" ]; then
    clear_aws_env
    aws-sso exec --profile "$ctx"
    break
  else
    echo "Invalid selection"
  fi
done
