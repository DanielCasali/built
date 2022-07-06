#!/usr/bin/env bash

set -ev

export BUILD_VERSION="0.0.2-SNAPSHOT"
export BUILD_DATE=`date +%Y-%m-%dT%T%z`

SCRIPT_DIR=$(dirname "$0")

DOCKER_CMD=podman
CODE_DIR=$(cd $SCRIPT_DIR/..; pwd)
echo $CODE_DIR
$DOCKER_CMD run --rm -v $HOME/.m2:/root/.m2 -v $CODE_DIR:/usr/src/mymaven -w /usr/src/mymaven maven:3.6-jdk-11-openj9 mvn -DskipTests package

cd ..
$DOCKER_CMD build \
      --build-arg BUILD_VERSION=$BUILD_VERSION \
      --build-arg BUILD_DATE=$BUILD_DATE \
      -t orders:latest -f Dockerfile_ppc64le
