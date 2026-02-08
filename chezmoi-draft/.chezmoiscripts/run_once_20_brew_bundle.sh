#!/usr/bin/env bash
set -euo pipefail

if [[ "${CHEZMOI_BOOTSTRAP:-0}" != "1" ]]; then
  echo "brew bundle: skipped (set CHEZMOI_BOOTSTRAP=1 to enable)" >&2
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "brew bundle: brew not found; install Homebrew first" >&2
  exit 0
fi

SOURCE_DIR="${CHEZMOI_SOURCE_DIR:-$HOME/.local/share/chezmoi}"
BREWFILE="${SOURCE_DIR}/Brewfile"

if [[ ! -f "$BREWFILE" ]]; then
  echo "brew bundle: Brewfile not found at $BREWFILE" >&2
  exit 0
fi

brew bundle --file "$BREWFILE"

