#!/bin/sh
set -eu

echo ">>> [01] install-fish: starting (user: $(whoami), home: $HOME, shell: $SHELL)"

# Ensure brew is on PATH
if [ "$(uname -s)" = "Linux" ]; then
  [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  # macOS: Apple Silicon
  [ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
  # macOS: Intel
  [ -f "/usr/local/bin/brew" ] && eval "$(/usr/local/bin/brew shellenv)"
fi

# Skip if fish is already installed
command -v fish >/dev/null 2>&1 && exit 0

brew install fish
