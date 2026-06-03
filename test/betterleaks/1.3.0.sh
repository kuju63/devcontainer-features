#!/bin/bash

set -e

source dev-container-features-test-lib
check "install successfully" bash -c "test -f /usr/local/bin/betterleaks"
check "have execution privilege" bash -c "test -x /usr/local/bin/betterleaks"

TAG_VERSION="1.3.0"

check "execute command" bash -c "betterleaks --version | grep 'betterleaks version $TAG_VERSION'"
reportResults
