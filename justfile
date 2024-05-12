# Justfile to ease development and deployment

# URL variable for Cloudflare deployment (override with `just url="$CF_PAGES_URL" prod`)
url := "https://www.zorrn.net"

# List all available commands
default:
    just --list --unsorted

# Serve locally
serve:
    zola serve

# Serve in the local network
serve-lan ip:
    zola serve -i 192.168.178.{{ip}} -u 192.168.178.{{ip}}

# Check for broken links
check-links:
    zola check

# Check prettiniess of code
lint:
    -bun run lint

# Make code pretty
lint-fix:
    bun run lint:fix

# Build production site (clean, build, minify)
prod: clean _build _minify

# Delete output directories
clean:
    rm -rf ./public ./public.min

# Production build (set base url, default is same as in config.toml)
_build:
    zola build --base-url {{url}}

# Minify production build (copy everything and minify supported fts)
_minify:
    minify -arso public.min/ public/

# Install proto and tools in .prototools (no need to reload shell because every line is in a subshell)
_install-tools:
    curl -fsSL https://moonrepo.dev/install/proto.sh | bash -s -- --yes
    proto use
