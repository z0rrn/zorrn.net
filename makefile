# Makefile to ease development and deployment

# Use Bash as shell
SHELL := /bin/bash
# List all recipes to be non-file targets
.PHONY: _default setup update lint serve serve-lan check-links production deploy clean _build _minify

# URL variable for Deployment (set to the same as in config.toml)
# manually override with `make url="https://example.org" production`
url := https://www.zorrn.net

_default: # List all available recipes (exclude recipes without a comment or a _ infront)
	@echo "Available recipes:"
	@grep -vE '^[[:space:]]' $(MAKEFILE_LIST) | grep -P '^((?!_).)*:.* #' | column -t -s ':'

setup: # Install all tools
	proto use
	bun install

update: # Update all tools
	proto outdated --update
	proto use
	bun update
	bun install

lint: # Check prettiniess of code
	bun run lint

serve: # Serve locally
	zola serve

serve-lan: # Serve in the local network (use with `make ip=91 serve-lan`)
	zola serve -i 192.168.178.$(ip) -u 192.168.178.$(ip)

check-links: # Check for broken links
	zola check

production: clean _build _minify # Build production site

deploy: production # Build and deploy to CF Pages
	bun run w:deploy

clean: # Delete output directories
	rm -rf ./public ./public.min

_build: # Production build (use url specified above)
	zola build --base-url $(url)

_minify: # Minify production build (copy everything and minify supported fts)
	minify -arso public.min/ public/
