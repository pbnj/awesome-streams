.DEFAULT_GOAL = help

.PHONY: help
help: ## Print help

.PHONY: all
all: fmt gen ## Do all steps

.PHONY: fmt
fmt: ## Format yaml
	prettier \
		--write \
		--parser yaml \
		awesome-streamers.yaml

.PHONY: gen
gen: ## Generate files
	go run main.go

.PHONY: publish
	PUBLISH_DATETIME := $(shell date)
publish: ## Publish files
	git add README.md awesome-streamers.json
	git commit -m "Published $(PUBLISH_DATETIME)"
	git push origin master
