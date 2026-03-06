#!/bin/sh
set -eu

# Ensure brew is on PATH (Linux)
if [ "$(uname -s)" = "Linux" ] && [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

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
if [ "$SHELL" != "$FISH" ]; then
  if command -v chsh >/dev/null 2>&1; then
    chsh -s "$FISH"
  else
    $SUDO usermod -s "$FISH" "$(whoami)" 2>/dev/null || true
  fi
fi
