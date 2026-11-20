#!/usr/bin/env bash
# Fails when a file named FAIL exists, so a change can fail on purpose.
set -euo pipefail
if [ -e FAIL ]; then echo "test: failing on purpose"; exit 1; fi
echo "test: ok"
