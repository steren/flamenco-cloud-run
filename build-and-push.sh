#!/bin/bash
set -e

REGISTRY="steren"

echo "Building Flamenco Manager image..."
docker build -t $REGISTRY/flamenco-manager:latest ./manager
echo "Pushing Flamenco Manager image..."
docker push $REGISTRY/flamenco-manager:latest

echo "Building Flamenco Worker image..."
docker build -t $REGISTRY/flamenco-worker:latest ./worker
echo "Pushing Flamenco Worker image..."
docker push $REGISTRY/flamenco-worker:latest

echo "Build and Push complete."
