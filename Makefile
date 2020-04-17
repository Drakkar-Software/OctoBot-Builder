BUILDX_VER=v0.3.1
IMAGE_NAME=drakkarsoftware/octobot
VERSION?=latest

install:
	mkdir -vp ~/.docker/cli-plugins/ ~/dockercache
	curl --silent -L "https://github.com/docker/buildx/releases/download/${BUILDX_VER}/buildx-${BUILDX_VER}.linux-amd64" > ~/.docker/cli-plugins/docker-buildx
	chmod a+x ~/.docker/cli-plugins/docker-buildx

prepare: install
	docker buildx create --use

build-push:
	docker buildx build --push --platform ${PLATFORMS} -t ${IMAGE_NAME}:${VERSION} .
