#!/usr/bin/env bash

set -ev

SCRIPT_DIR=$(dirname "$0")


export COMMIT=latest
DOCKER_CMD=podman

CODE_DIR=$(cd $SCRIPT_DIR/..; pwd)
echo $CODE_DIR

cd ..

$DOCKER_CMD build -t front-end:${COMMIT} .
