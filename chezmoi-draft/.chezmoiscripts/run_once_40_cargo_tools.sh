#!/usr/bin/env bash
set -euo pipefail

if [[ "${CHEZMOI_BOOTSTRAP:-0}" != "1" ]]; then
  echo "cargo tools: skipped (set CHEZMOI_BOOTSTRAP=1 to enable)" >&2
  exit 0
fi

if command -v cargo >/dev/null 2>&1; then
  CARGO="cargo"
elif [[ -x "$HOME/.cargo/bin/cargo" ]]; then
  CARGO="$HOME/.cargo/bin/cargo"
else
  echo "cargo tools: cargo not found; install Rust toolchain first" >&2
  exit 0
fi

TOOLS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/bootstrap/cargo.txt"
if [[ ! -f "$TOOLS_FILE" ]]; then
  exit 0
fi

while IFS= read -r crate; do
  [[ -z "$crate" ]] && continue
  [[ "$crate" =~ ^# ]] && continue
  "$CARGO" install "$crate" --locked || true
done < "$TOOLS_FILE"

