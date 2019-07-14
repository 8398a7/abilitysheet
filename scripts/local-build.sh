#!/bin/bash -xe

tag=$(git describe --tags --abbrev=10)

docker build --cache-from gcr.io/${GCLOUD_PROJECT}/abilitysheet-base:latest -t gcr.io/${GCLOUD_PROJECT}/abilitysheet-base:latest . -f build/base.Dockerfile
docker build --cache-from gcr.io/${GCLOUD_PROJECT}/abilitysheet:latest -t gcr.io/${GCLOUD_PROJECT}/abilitysheet:$tag . -f build/Dockerfile
docker push gcr.io/${GCLOUD_PROJECT}/abilitysheet:$tag
