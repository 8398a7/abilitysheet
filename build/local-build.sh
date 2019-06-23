#!/bin/bash -xe

docker build --cache-from gcr.io/iidx-app/abilitysheet-base:latest -t gcr.io/iidx-app/abilitysheet-base:latest . -f build/base.Dockerfile
docker build --cache-from gcr.io/iidx-app/abilitysheet:latest -t gcr.io/iidx-app/abilitysheet:latest . -f build/Dockerfile
docker push gcr.io/iidx-app/abilitysheet-base:latest
docker push gcr.io/iidx-app/abilitysheet:latest
