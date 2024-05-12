#! /usr/bin/env bash
# This script is used to build the project on Clouflare Pages for a production build.

set -euo pipefail

# Install Proto and tools
curl -fsSL https://moonrepo.dev/install/proto.sh | bash -s -- --yes
source ~/.bash_profile # Reload bash to use `proto` command
proto use

# Run build script
just url="$CF_PAGES_URL" prod
