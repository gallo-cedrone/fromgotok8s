# Don't assume PATH settings
export PATH := $(PATH):$(GOPATH)/bin
BINARY_NAME   := fromgotok8s
GO_FILES     := ./src/
TRAVIS_TAG ?= latest
TEST_DEPS     = github.com/axw/gocov/gocov github.com/AlekSi/gocov-xml

compile:
	@echo "=== [ compile ]: building $(BINARY_NAME)..."
	@go build -v -o bin/$(BINARY_NAME) $(GO_FILES)

test: vendor
	@echo "=== [ test ]: running unit tests..."
	@go clean -cache -testcache
	@gocov test $(GO_FILES) | gocov report

vendor:
	@echo "=== [ vendor ]: updating vendor folder..."
	@go get -v $(TEST_DEPS)
	@go mod vendor

integration-test: compile
	@echo "=== [ integration test ]: running integration tests..."
	@go clean -cache -testcache
	@docker-compose -f tests/integration/docker-compose.yml up -d --build
	@go test -v -tags=integration ./tests/integration/. || (ret=$$?; docker-compose -f tests/integration/docker-compose.yml down && exit $$ret)
	@docker-compose -f tests/integration/docker-compose.yml down

image:
	@echo "=== [ image ]: building image..."
	@docker build -t pgallina/fromgotok8s:latest .

push-image:
	@echo "=== [ push-image ]: pushing image..."
	@docker login --username $(DOCKER_USERNAME) --password $(DOCKER_PASSWORD)
	@docker push pgallina/fromgotok8s:latest

push-app:
	@echo "=== [ push-app ]: pushing app to k8s..."
	@helm upgrade --install fromgotok8s-${TRAVIS_TAG} static-gallo-cedrone-repo/fromgotok8s   --set image.version=${TRAVIS_TAG}

.PHONY: compile test integration-test vendor image push-image push-app
