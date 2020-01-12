#!/bin/bash -xe

base=docker.pkg.github.com/8398a7/abilitysheet/abilitysheet-base:latest
tag=$(git describe --tags --abbrev=10)

docker build --cache-from $base -t $base -f build/base.Dockerfile .
docker push $base
docker build -t gcr.io/${GCLOUD_PROJECT}/abilitysheet:$tag . -f build/Dockerfile
docker push gcr.io/${GCLOUD_PROJECT}/abilitysheet:$tag
