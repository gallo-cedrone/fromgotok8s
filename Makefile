# Don't assume PATH settings
export PATH := $(PATH):$(GOPATH)/bin
BINARY_NAME := fromgotok8s
GO_FILES    := ./src/
TRAVIS_TAG   := $(TRAVIS_TAG)
TRAVIS_BRANCH   := $(TRAVIS_BRANCH)
TEST_DEPS    = github.com/axw/gocov/gocov github.com/AlekSi/gocov-xml

vendor:
	@echo "=== [ vendor ]: updating vendor folder..."
	@go get -v $(TEST_DEPS)
	@go mod vendor

test: vendor
	@echo "=== [ test ]: running unit tests..."
	@go clean -cache -testcache
	@gocov test $(GO_FILES) | gocov report

compile: vendor
	@echo "=== [ compile ]: building $(BINARY_NAME)..."
	@go build -v -o bin/$(BINARY_NAME) $(GO_FILES)

integration-test: compile
	@echo "=== [ integration test ]: running integration tests..."
	@go clean -cache -testcache
	@docker-compose -f tests/integration/docker-compose.yml up -d --build
	@go test -v -tags=integration ./tests/integration/. || (ret=$$?; docker-compose -f tests/integration/docker-compose.yml down && exit $$ret)
	@docker-compose -f tests/integration/docker-compose.yml down

image:
	@echo "=== [ image ]: building image..."
	@docker build -t pgallina/fromgotok8s:latest .

push-image: image
	@echo "=== [ push-image ]: pushing image..."
	@docker login --username $(DOCKER_USERNAME) --password $(DOCKER_PASSWORD)
	@docker push pgallina/fromgotok8s:latest

add-repo:
	@echo "=== [ add-repo ]: adding static repository to helm..."
	@helm repo add static-gallo-cedrone-repo https://gallo-cedrone.github.io/fromgotok8s
	@helm repo update

push-app: add-repo push-image
	@echo "=== [ push-app ]: pushing app to k8s..."
	@helm upgrade --install fromgotok8s_${TRAVIS_BRANCH}_${TRAVIS_TAG} --namespace ${TRAVIS_BRANCH} --namespace static-gallo-cedrone-repo/fromgotok8s   --set image.version=${TRAVIS_BRANCH}-${TRAVIS_TAG}

changelog:
	@echo "=== [ changelog ]: generating changelog..."
	@echo "## CHANGELOG" > CHANGELOG.md
	@git --no-pager log master --date=short --pretty=format:"#### %ad%x09%an%x09%t%x09%s%n%n%b" --no-merges  >> CHANGELOG.md

.PHONY: changelog compile test integration-test vendor image push-image push-app changelog add-repo
