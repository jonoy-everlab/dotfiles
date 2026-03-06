#!/bin/sh
set -eu

# Ensure brew is on PATH (Linux)
if [ "$(uname -s)" = "Linux" ] && [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

FISH="$(command -v fish)"

# Add fish to /etc/shells if not already there
grep -qF "$FISH" /etc/shells || echo "$FISH" | sudo tee -a /etc/shells

# Set fish as default shell (chsh may not be available on all systems)
if command -v chsh >/dev/null 2>&1; then
  [ "$SHELL" = "$FISH" ] || chsh -s "$FISH"
elif [ -f /etc/passwd ]; then
  sudo usermod -s "$FISH" "$(whoami)" 2>/dev/null || true
fi
