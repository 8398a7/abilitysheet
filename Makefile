TAG := $(shell git describe --tags --abbrev=10)
IMAGE := ghcr.io/8398a7/abilitysheet/app

.PHONY: build
build:
	docker build --platform linux/amd64 -t $(IMAGE):$(TAG) .
.PHONY: push
push:
	docker push $(IMAGE):$(TAG)
