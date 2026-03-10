#!/bin/sh
set -eu

echo ">>> [00] install-homebrew: starting (user: $(whoami), home: $HOME, shell: $SHELL)"

# Use sudo only if not already root
if [ "$(id -u)" = "0" ]; then
  SUDO=""
else
  SUDO="sudo"
fi

# Install build dependencies on Linux
if [ "$(uname -s)" = "Linux" ]; then
  if command -v apt-get >/dev/null 2>&1; then
    $SUDO apt-get update && $SUDO apt-get install -y build-essential curl git
  elif command -v dnf >/dev/null 2>&1; then
    $SUDO dnf install -y gcc curl git
  fi
fi

# Skip if already installed
command -v brew >/dev/null 2>&1 && exit 0

NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add brew to PATH on Linux for subsequent scripts
if [ "$(uname -s)" = "Linux" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
