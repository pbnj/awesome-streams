.PHONY: all
all: fmt-yaml gen fmt-markdown ## Do All The Steps!

.PHONY: fmt
fmt: fmt-yaml fmt-markdown ## Format files

.PHONY: fmt-markdown
fmt-markdown: ## Format markdown files
	prettier \
		--write \
		--parser markdown \
		*.md

.PHONY: fmt-yaml
fmt-yaml: ## Format yaml
	prettier \
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
