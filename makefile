# Makefile to ease development and deployment

# Use Bash as shell
SHELL := /bin/bash

# List all recipes to be non-file targets
.PHONY: default serve serve-lan check-links lint lint-fix prod clean _build _minify _install-tools

# URL variable for Cloudflare deployment (override with `make url="https://example.org" prod`)
url = https://www.zorrn.net

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
	-bun run lint

lint-fix: # Make code pretty
	bun run lint:fix

prod: clean _build _minify # Build production site (clean, build, minify)

cf: _install-tools _build-cf _minify # Build on Cloudflare Pages

clean: # Delete output directories
	rm -rf ./public ./public.min

_build: # Production build (set base url, default is same as in config.toml)
	zola build --base-url $(url)

# Use public URL on prod and preview URL on preview
ifeq ($(CF_PAGES_BRANCH), main)
_build-cf: # Production build (set base url, default is same as in config.toml)
	zola build --base-url $(url)
else
_build-cf: # Production build (set base url, default is same as in config.toml)
	zola build --base-url $(CF_PAGES_URL)
endif

_minify: # Minify production build (copy everything and minify supported fts)
	minify -arso public.min/ public/

_install-tools: # Install proto and tools in .prototools (because every line is in a subshell)
	curl -fsSL https://moonrepo.dev/install/proto.sh | bash -s -- --yes
	echo 'export PATH="/opt/buildhome/.proto/shims:/opt/buildhome/.proto/bin:$$PATH"' >> ~/.bashrc && echo $$PATH
	echo $$PATH
	source ~/.bashrc && echo $$PATH
	proto use
