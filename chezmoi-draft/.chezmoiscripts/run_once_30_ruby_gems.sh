#!/usr/bin/env bash
set -euo pipefail

if [[ "${CHEZMOI_BOOTSTRAP:-0}" != "1" ]]; then
  echo "ruby gems: skipped (set CHEZMOI_BOOTSTRAP=1 to enable)" >&2
  exit 0
fi

if ! command -v gem >/dev/null 2>&1; then
  echo "ruby gems: gem not found; install Ruby first (recommend: Homebrew ruby)" >&2
  exit 0
fi

GEMS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/bootstrap/gems.txt"
if [[ ! -f "$GEMS_FILE" ]]; then
  exit 0
fi

while IFS= read -r gem_name; do
  [[ -z "$gem_name" ]] && continue
  [[ "$gem_name" =~ ^# ]] && continue
  gem install -N "$gem_name"
done < "$GEMS_FILE"

