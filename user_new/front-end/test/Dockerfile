#FROM node:4-alpine

#RUN apk update && apk add make

#RUN npm install -g phantomjs-prebuilt
#RUN npm install -g casperjs

#RUN addgroup mygroup && adduser -D -G mygroup myuser && mkdir -p /usr/src/app && chown -R myuser /usr/src/app

#WORKDIR /usr/src/app
#COPY package.json /usr/src/app/
#COPY yarn.lock /usr/src/app/
#RUN chown myuser /usr/src/app/yarn.lock

#USER myuser
#RUN yarn install

#COPY . /usr/src/app

FROM node:4-alpine

RUN apk update && apk add make && apk add bash

RUN apk add python

## Remark: phantomjs-prebuilt does not work with node:4-alpine
#RUN npm install -g phantomjs-prebuilt 

RUN set -ex \
  && apk add --no-cache --virtual .build-deps ca-certificates openssl \
  && wget -qO- "https://github.com/dustinblackman/phantomized/releases/download/2.1.1/dockerized-phantomjs.tar.gz" | tar xz -C / \
  && npm install -g phantomjs \
  && apk del .build-deps

RUN npm install -g casperjs

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app
