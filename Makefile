default: docker_build

DOCKER_IMAGE ?= ianmward/k8s-helm
GIT_BRANCH ?= `git rev-parse --abbrev-ref HEAD`
GIT_REVISION ?= `git rev-parse --short HEAD`

ifeq ($(GIT_BRANCH), master)
	DOCKER_TAG = latest
else
	DOCKER_TAG = $(GIT_BRANCH)
endif

docker_build:
	docker build \
	  --build-arg VCS_REF=`git rev-parse --short HEAD` \
	  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	  -t $(DOCKER_IMAGE):$(GIT_REVISION) .
	  
docker_push:
	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(GIT_REVISION)

test:
	docker run $(DOCKER_IMAGE):$(GIT_REVISION) version
