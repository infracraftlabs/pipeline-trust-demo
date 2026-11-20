#!/usr/bin/env bash
# Pretend deploy: prints what it would deploy. Never prints the token itself.
set -euo pipefail
image="$1"
case "$image" in *@sha256:*) ;; *) echo "refusing: '$image' is not pinned to a digest"; exit 1;; esac
echo "deploying $image"
echo "DEPLOY_TOKEN length: ${#DEPLOY_TOKEN}"
