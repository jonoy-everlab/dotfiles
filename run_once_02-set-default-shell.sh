#!/bin/sh
set -eu

# Ensure brew is on PATH (Linux)
if [ "$(uname -s)" = "Linux" ] && [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

FISH="$(command -v fish)"

# Add fish to /etc/shells if not already there
grep -qF "$FISH" /etc/shells || echo "$FISH" | sudo tee -a /etc/shells

# Set fish as default shell
[ "$SHELL" = "$FISH" ] || chsh -s "$FISH"
