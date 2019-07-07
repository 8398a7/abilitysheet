#!/bin/bash -x

gcloud builds submit --config build/cloudbuild.yaml . \
  --substitutions=TAG_NAME="$(git describe --tags --abbrev=10)"
