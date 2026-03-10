#!/bin/sh
set -eu

echo ">>> [02] set-default-shell: starting"

# Ensure brew is on PATH
if [ "$(uname -s)" = "Linux" ]; then
  [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  [ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
  [ -f "/usr/local/bin/brew" ] && eval "$(/usr/local/bin/brew shellenv)"
fi

# Skip if fish is not installed
command -v fish >/dev/null 2>&1 || exit 0

FISH="$(command -v fish)"

# Use sudo only if not already root
if [ "$(id -u)" = "0" ]; then
  SUDO=""
else
  SUDO="sudo"
fi

# Add fish to /etc/shells if not already there
grep -qF "$FISH" /etc/shells || echo "$FISH" | $SUDO tee -a /etc/shells

# Set fish as default shell
if [ "${SHELL:-}" != "$FISH" ]; then
  if [ "$(uname -s)" = "Linux" ]; then
    # chsh requires PAM auth in containers; usermod does not
    $SUDO usermod -s "$FISH" "$(whoami)"
  else
    chsh -s "$FISH"
  fi
fi
