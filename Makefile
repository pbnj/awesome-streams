.DEFAULT_GOAL = help

.PHONY: help
help: ## Print help

.PHONY: fmt
fmt: ## Format yaml
	prettier \
		--write \
		--parser yaml \
		awesome-streamers.yaml
