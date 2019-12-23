PROJECT := awesome-streams

.DEFAULT_GOAL := help

.PHONY: dev
dev: ## Launch dev container
	@docker run \
		--rm \
		-it \
		-v $(PWD):/$(PROJECT) \
		-w /$(PROJECT) \
		pbnj:dev

.PHONY: all
all: fmt-yaml gen fmt-markdown ## Do All The Steps!

.PHONY: fmt
fmt: fmt-yaml fmt-markdown ## Format files

.PHONY: fmt-markdown
fmt-markdown: ## Format markdown files
	npx prettier \
		--write \
		--parser markdown \
		*.md

.PHONY: fmt-yaml
fmt-yaml: ## Format yaml
	npx prettier \
		--write \
		--parser yaml \
		awesome-streamers.yaml

.PHONY: gen
gen: ## Generate files
	go run main.go
	$(MAKE) fmt-markdown

.PHONY: publish
publish: ## Publish files
	git add README.md awesome-streamers.json
	git commit -m "Published $(shell date)"
	git push origin master

.PHONY: help
help: ## Print help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
