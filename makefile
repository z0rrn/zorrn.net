# Makefile to ease development and deployment

# Use Bash as shell
SHELL := /bin/bash
# List all recipes to be non-file targets
.PHONY: _default serve serve-lan check-links lint lint-fix proto proto-up production clean _build _minify

# URL variable for Deployment (set to the same as in config.toml)
# automatically overriden for Cloudflare Preview
# manually override with `make url="https://example.org" production`
ifeq ($(CF_PAGES), 1)
ifeq ($(CF_PAGES_BRANCH), main)
url := https://www.zorrn.net
else
url := $(CF_PAGES_URL)
endif
else
url := https://www.zorrn.net
endif

_default: # List all available commands (exclude recipes without a comment or a _ infront)
	@echo "Available recipes:"
	@grep -vE '^[[:space:]]' $(MAKEFILE_LIST) | grep -P '^((?!_).)*:.* #' | column -t -s ':'

serve: # Serve locally
	zola serve

serve-lan: # Serve in the local network (use with `make ip=91 serve-lan`)
	zola serve -i 192.168.178.$(ip) -u 192.168.178.$(ip)

check-links: # Check for broken links
	zola check

lint: # Check prettiniess of code
	bun run lint

lint-fix: # Make code pretty
	bun run lint:fix

proto: # Install Prototools
	proto use

proto-up: # Update Prototools
	proto outdated --update
	proto use

production: clean _build _minify # Build production site

clean: # Delete output directories
	rm -rf ./public ./public.min

_build: # Production build (use url specifid above)
	zola build --base-url $(url)

_minify: # Minify production build (copy everything and minify supported fts)
	minify -arso public.min/ public/
