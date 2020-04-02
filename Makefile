# Don't assume PATH settings
export PATH := $(PATH):$(GOPATH)/bin
BINARY_NAME := fromgotok8s
GO_FILES    := ./src/
TRAVIS_TAG   := $(TRAVIS_TAG)
TRAVIS_BRANCH   := $(TRAVIS_BRANCH)

vendor:
	@echo "=== [ vendor ]: updating vendor folder..."
	@dep ensure

test: vendor
	@echo "=== [ test ]: running unit tests..."
	@go test $(GO_FILES) -v -covermode=count -coverprofile=coverage.out

compile: vendor
	@echo "=== [ compile ]: building $(BINARY_NAME)..."
	@go build -v -o bin/$(BINARY_NAME) $(GO_FILES)

integration-test: compile
	@echo "=== [ integration test ]: running integration tests..."
	@docker-compose -f tests/integration/docker-compose.yml up -d --build
	@go test -v -tags=integration ./tests/integration/. || (ret=$$?; docker-compose -f tests/integration/docker-compose.yml down && exit $$ret)
	@docker-compose -f tests/integration/docker-compose.yml down

image:
	@echo "=== [ image ]: building image..."
	docker build -t pgallina/fromgotok8s:${TRAVIS_BRANCH}-${TRAVIS_TAG} .

push-image: image
	@echo "=== [ push-image ]: pushing image..."
	@docker login --username pgallina --password $(DOCKER_PASSWORD)
	docker push pgallina/fromgotok8s:${TRAVIS_BRANCH}-${TRAVIS_TAG}

set-cluster:
	@echo "=== [ set-cluster ]: Setting Kubernetes Cluster..."
	@gcloud auth activate-service-account --key-file=keyfile.json
	@gcloud config set project $(GCLOUD_ACCOUNT_NUMBER)
	@gcloud container clusters get-credentials fromgotok8s --zone us-central1-c

add-repo:
	@echo "=== [ add-repo ]: adding static repository to helm..."
	@helm repo add static-gallo-cedrone-repo https://gallo-cedrone.github.io/fromgotok8s
	@helm repo update

push-app: add-repo push-image
	@echo "=== [ push-app ]: pushing app to k8s..."
	kubectl create namespace ${TRAVIS_BRANCH} || true
	helm upgrade fromgotok8s_${TRAVIS_BRANCH}_${TRAVIS_TAG} static-gallo-cedrone-repo/fromgotok8s --install --namespace ${TRAVIS_BRANCH} --set image.version=${TRAVIS_BRANCH}-${TRAVIS_TAG}

changelog:
	@echo "=== [ changelog ]: generating changelog..."
	@echo "## CHANGELOG" > CHANGELOG.md
	@git --no-pager log master --date=short --pretty=format:"#### %ad%x09%an%x09%t%x09%s%n%n%b" --no-merges  >> CHANGELOG.md

tools-and-vars:
	@echo "=== [ tools-and-vars ]: installing tools..."
	@sudo apt-get install apt-transport-https ca-certificates gnupg
	@curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
	@sudo apt-get update && sudo apt-get install google-cloud-sdk
	@curl https://get.helm.sh/helm-v3.1.1-linux-amd64.tar.gz > helm-v3.1.1-linux-amd64.tar.gz
	@tar -zxvf helm-v3.1.1-linux-amd64.tar.gz
	@sudo mv linux-amd64/helm /usr/local/bin/helm
	@curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl
	@chmod +x ./kubectl
	@sudo mv ./kubectl /usr/local/bin/kubectl
	@echo ${GCLOUD_SERVICE_ACCOUNT} | base64 -d > keyfile.json


.PHONY: changelog compile test integration-test vendor image push-image push-app changelog add-repo set-cluster tools-and-vars
