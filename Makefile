REGISTRY?=registry.life-team.net/hype
HASH=$(shell git rev-parse --short HEAD)
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)


CONTAINER=$(shell basename `pwd`)

tag: container
	docker tag ${REGISTRY}/${CONTAINER} ${REGISTRY}/${CONTAINER}-${GIT_BRANCH}:${HASH}
	docker tag ${REGISTRY}/${CONTAINER} ${REGISTRY}/${CONTAINER}-${GIT_BRANCH}:latest

container:
	docker build -t ${REGISTRY}/${CONTAINER} .

push: tag
	docker push ${REGISTRY}/${CONTAINER}-${GIT_BRANCH}:${HASH}
	docker push ${REGISTRY}/${CONTAINER}-${GIT_BRANCH}:latest
