#!/usr/bin/env bash
set -euo pipefail

if [[ "${CHEZMOI_BOOTSTRAP:-0}" != "1" ]]; then
  echo "npm global: skipped (set CHEZMOI_BOOTSTRAP=1 to enable)" >&2
  exit 0
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "npm global: npm not found; install Node first" >&2
  exit 0
fi

PKGS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/bootstrap/npm-global.txt"
if [[ ! -f "$PKGS_FILE" ]]; then
  exit 0
fi

while IFS= read -r pkg; do
  [[ -z "$pkg" ]] && continue
  [[ "$pkg" =~ ^# ]] && continue
  npm install -g "$pkg" || true
done < "$PKGS_FILE"

