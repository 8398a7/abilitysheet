#!/bin/bash -xe

tag=$(git describe --tags --abbrev=10)

docker build --cache-from 8398a7/abilitysheet-base:latest -t 8398a7/abilitysheet-base:latest . -f build/base.Dockerfile
docker push 8398a7/abilitysheet-base:latest
docker build -t gcr.io/${GCLOUD_PROJECT}/abilitysheet:$tag . -f build/Dockerfile
docker push gcr.io/${GCLOUD_PROJECT}/abilitysheet:$tag
