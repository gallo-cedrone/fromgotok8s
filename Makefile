# Don't assume PATH settings
export PATH := $(PATH):$(GOPATH)/bin
BINARY_NAME   = fromgotok8s
GO_FILES     := ./src/

compile:
	@echo "=== [ compile ]: building $(BINARY_NAME)..."
	@go build -v -o bin/$(BINARY_NAME) $(GO_FILES)

test:
	@echo "=== [ test ]: running unit tests..."
	@go test $(GO_FILES)

vendor:
	@echo "=== [ vendor ]: updating vendor folder..."
	@go mod vendor

integration-test:
	@echo "=== [ integration test ]: running integration tests..."
	@docker-compose -f tests/integration/docker-compose.yml up -d --build
	@go test -v -tags=integration ./tests/integration/. || (ret=$$?; docker-compose -f tests/integration/docker-compose.yml down && exit $$ret)
	@docker-compose -f tests/integration/docker-compose.yml down

image:
	@echo "=== [ image ]: building image..."
	@docker build -t pgallina/fromgotok8s:latest .

push-image:
	@echo "=== [ push ]: pushing image..."
	@docker login --username $(DOCKER_USERNAME) --password $(DOCKER_PASSWORD)
	@docker push pgallina/fromgotok8s:latest

.PHONY: compile test integration-test vendor image push
