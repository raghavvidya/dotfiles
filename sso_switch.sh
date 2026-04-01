#!/usr/bin/env bash

# Function to clear AWS env vars
clear_aws_env() {
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
  unset AWS_PROFILE
  unset AWS_DEFAULT_PROFILE
}

profiles=($(aws-sso|egrep 'dev|test|prod'|grep -i admin|grep -v qs-admin|sort -k3,3|awk -F"|" '{print $4}'))

echo "Select AWS SSO profile:"

select PROFILE in $profiles; do
  if [ -n "$PROFILE" ]; then
    echo "Switching to $PROFILE..."

    # Clear existing credentials first
    clear_aws_env

    # Login (optional but recommended)
    aws-sso login --profile "$PROFILE"

    # Load credentials into current shell
    aws-sso-profile "$PROFILE"

    break
  else
    echo "Invalid selection"
  fi
done
