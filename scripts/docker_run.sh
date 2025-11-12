#!/usr/bin/env bash
set -euo pipefail
IMAGE="hello-world-local:latest"
docker build -t "$IMAGE" .
docker run --rm "$IMAGE"
