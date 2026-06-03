#!/bin/bash

set -e

source dev-container-features-test-lib
check "install successfully" bash -c "test -f /usr/local/bin/betterleaks"
check "have execution privilege" bash -c "test -x /usr/local/bin/betterleaks"

# Get the latest version of betterleaks from GitHub Releases
VERSION=$(curl -sL https://api.github.com/repos/betterleaks/betterleaks/releases/latest | jq -r '.tag_name')
TAG_VERSION=$(echo "$VERSION" | sed 's/^v//')

check "execute command" bash -c "betterleaks --version | grep 'betterleaks version $TAG_VERSION'"
reportResults
