TAG := $(shell git describe --tags --abbrev=10)
BASE_IMAGE := docker.pkg.github.com/8398a7/abilitysheet/abilitysheet-base
IMAGE := gcr.io/iidx-app/abilitysheet

.PHONY: pull
	docker pull $(BASE_IMAGE):latest
.PHONY: build
build:
	docker build --cache-from $(BASE_IMAGE):latest -t $(BASE_IMAGE):latest -f build/base.Dockerfile .
	docker build -t $(IMAGE):$(TAG) -f build/Dockerfile .
.PHONY: push
push:
	docker push $(BASE_IMAGE):latest
	docker push $(IMAGE):$(TAG)
