#!/bin/bash -x
set -e

# This file is install script for betterleaks devcontainer feature. It will be download betterleaks binary file from GitHub Releases and install on /usr/local/bin. Need to require to set execution privilege to betterleaks binary file.

# Check linux distribution. Supported linux distribution: debian, ubuntu, centos, RedHat Linux(UBI).
function os_type() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

# Install prerequisite packages. Supported package manager: apt-get, yum, dnf.
function install_prerequisite() {
    if [ -x "$(command -v apt-get)" ]; then
        apt-get update
        apt-get install -y --no-install-recommends curl ca-certificates tar gzip jq \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*
    elif [ -x "$(command -v yum)" ]; then
        yum install -y curl jq
    elif [ -x "$(command -v dnf)" ]; then
        dnf install -y ca-certificates tar gzip jq curl-minimal \
            && dnf clean all
    elif [ -x "$(command -v microdnf)" ]; then
        microdnf install -y ca-certificates tar gzip jq curl-minimal \
            && microdnf clean all
    else
        echo "Error: Unsupported package manager. Supported package manager: apt-get, yum, dnf, microdnf."
        exit 1
    fi
}

OS=$(os_type)
if [ "$OS" != "debian" ] && [ "$OS" != "ubuntu" ] && [ "$OS" != "centos" ] && [ "$OS" != "rhel" ]; then
    echo "Error: Unsupported linux distribution $OS. Supported linux distribution: debian, ubuntu, centos, RedHat Linux(UBI)."
    exit 1
fi

if ([ -x "$(which curl)" ] || [ -x "$(which wget)" ]) && [ -x "$(which jq)" ] && [ -x "$(which tar)" ]; then
    echo "curl, wget, jq, and tar are already installed."
else
    echo "Installing prerequisite packages..."
    install_prerequisite
fi

# Download betterleaks binary file from GitHub Releases
echo "Downloading betterleaks binary file from GitHub Releases..."

TAG_VERSION=$(echo "$VERSION" | sed 's/^v//')
if [ "$VERSION" = "latest" ]; then
    VERSION=$(curl -sL https://api.github.com/repos/betterleaks/betterleaks/releases/latest | jq -r '.tag_name')
    TAG_VERSION=$(echo "$VERSION" | sed 's/^v//')
    echo "Latest betterleaks version is $VERSION"
fi

# Check architecture and download the corresponding betterleaks binary file
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    echo "Architecture is x86_64, downloading betterleaks for x86_64..."
    URL="https://github.com/betterleaks/betterleaks/releases/download/${VERSION}/betterleaks_${TAG_VERSION}_linux_x64.tar.gz"
elif [ "$ARCH" = "aarch64" ]; then
    echo "Architecture is aarch64, downloading betterleaks for aarch64..."
    URL="https://github.com/betterleaks/betterleaks/releases/download/${VERSION}/betterleaks_${TAG_VERSION}_linux_arm64.tar.gz"
elif [ "$ARCH" = "arm64" ]; then
    echo "Architecture is arm64, downloading betterleaks for arm64..."
    URL="https://github.com/betterleaks/betterleaks/releases/download/${VERSION}/betterleaks_${TAG_VERSION}_linux_arm64.tar.gz"
else
    echo "Error: Unsupported architecture $ARCH"
    exit 1
fi

if [ $(which curl) ]; then
    curl -L -o betterleaks.tar.gz "$URL"
elif [ $(which wget) ]; then
    wget -O betterleaks.tar.gz "$URL"
else
    echo "Error: curl or wget is required to download betterleaks."
    exit 1
fi

# Extract betterleaks binary file from tar.gz
echo "Extracting betterleaks binary file from tar.gz..."
tar -xzf betterleaks.tar.gz -C .

chmod +x betterleaks
# Move betterleaks binary file to /usr/local/bin
echo "Moving betterleaks binary file to /usr/local/bin..."
mv betterleaks /usr/local/bin/betterleaks
echo "betterleaks has been installed successfully!"
