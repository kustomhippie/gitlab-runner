#!/bin/bash
set -e

mkdir -p /home/gitlab-runner/.gitlab-runner/
cp /scripts/config.toml /home/gitlab-runner/.gitlab-runner/

# Set up environment variables for cache
if [[ -f /secrets/accesskey && -f /secrets/secretkey ]]; then
    export S3_ACCESS_KEY=$(cat /secrets/accesskey)
    export S3_SECRET_KEY=$(cat /secrets/secretkey)
fi

if [[ -f /secrets/runner-registration-token ]]; then
    export REGISTRATION_TOKEN=$(cat /secrets/runner-registration-token)
fi

if ! sh /scripts/register-the-runner; then
    exit 1
fi

if ! bash /scripts/pre-entrypoint-script; then
    exit 1
fi

exec /entrypoint run --user=gitlab-runner \
    --working-directory=/home/gitlab-runner
