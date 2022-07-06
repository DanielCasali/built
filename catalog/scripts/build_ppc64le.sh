#!/usr/bin/env sh

set -ev

export BUILD_VERSION="0.0.2-SNAPSHOT"
export BUILD_DATE=`date +%Y-%m-%dT%T%z`
export COMMIT=latest
SCRIPT_DIR=$(dirname "$0")

if [ -z "$COMMIT" ] ; then
    echo "Cannot find COMMIT env var"
    exit 1
fi

DOCKER_CMD=podman
CODE_DIR=$(cd $SCRIPT_DIR/..; pwd)
echo $CODE_DIR
 
mkdir -p $CODE_DIR/build
BUILD_DIR=$CODE_DIR/build

cp -r $CODE_DIR/docker $BUILD_DIR/
cp -r $CODE_DIR/images/ $BUILD_DIR/docker/catalogue/images/
cp -r $CODE_DIR/cmd/ $BUILD_DIR/docker/catalogue/cmd/
cp $CODE_DIR/*.go $BUILD_DIR/docker/catalogue/
mkdir -p $BUILD_DIR/docker/catalogue/vendor/ && \
cp $CODE_DIR/vendor/manifest $BUILD_DIR/docker/catalogue/vendor/

$DOCKER_CMD build \
  --build-arg BUILD_VERSION=$BUILD_VERSION \
  --build-arg BUILD_DATE=$BUILD_DATE \
  --build-arg COMMIT=$COMMIT \
  -t catalogue:${COMMIT} \
  -f $BUILD_DIR/docker/catalogue/Dockerfile_ppc64le $BUILD_DIR/docker/catalogue;

$DOCKER_CMD build \
  -t catalogue-db:${COMMIT} \
  -f $BUILD_DIR/docker/catalogue-db/Dockerfile_ppc64le $BUILD_DIR/docker/catalogue-db/;

rm -rf $BUILD_DIR
