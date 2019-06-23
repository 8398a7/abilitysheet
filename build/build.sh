#!/bin/bash -x

gcloud builds submit --config build/cloudbuild.yaml .
