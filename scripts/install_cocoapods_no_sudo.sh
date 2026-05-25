#!/bin/bash
# Install CocoaPods WITHOUT admin password.
# Everything installs under your home folder (~/.homebrew).
set -e

echo "=============================================="
echo " CocoaPods install (no admin password)"
echo "=============================================="
echo ""

HOME_BREW="$HOME/.homebrew"

if [ ! -x "$HOME_BREW/bin/brew" ]; then
  echo "[1/3] Installing Homebrew to ~/.homebrew ..."
  mkdir -p "$HOME_BREW"
  curl -fsSL https://github.com/Homebrew/brew/tarball/master | tar xz --strip-components 1 -C "$HOME_BREW"
else
  echo "[1/3] Homebrew already at ~/.homebrew"
fi

export PATH="$HOME_BREW/bin:$PATH"
eval "$("$HOME_BREW/bin/brew" shellenv)"

echo ""
echo "[2/3] Installing CocoaPods ..."
brew install cocoapods

echo ""
echo "[3/3] Verifying ..."
pod --version

ZSHRC="$HOME/.zshrc"
LINE='export PATH="$HOME/.homebrew/bin:$PATH"'
if [ -f "$ZSHRC" ] && grep -q '.homebrew/bin' "$ZSHRC"; then
  echo "PATH already in ~/.zshrc"
else
  echo "" >> "$ZSHRC"
  echo "# Homebrew (user install, no admin)" >> "$ZSHRC"
  echo "$LINE" >> "$ZSHRC"
fi

echo ""
echo "Done. New Terminal, then:"
echo "  cd \"/Users/ccs_ac/profile-app\""
echo "  ./scripts/run_ios_no_sudo.sh"
