#!/bin/sh
set -eu

# Install build dependencies on Linux
if [ "$(uname -s)" = "Linux" ]; then
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y build-essential curl git
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y gcc curl git
  fi
fi

# Skip if already installed
command -v brew >/dev/null 2>&1 && exit 0

NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add brew to PATH on Linux for subsequent scripts
if [ "$(uname -s)" = "Linux" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
