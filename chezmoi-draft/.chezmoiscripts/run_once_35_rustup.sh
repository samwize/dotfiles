#!/usr/bin/env bash
set -euo pipefail

if [[ "${CHEZMOI_BOOTSTRAP:-0}" != "1" ]]; then
  echo "rustup: skipped (set CHEZMOI_BOOTSTRAP=1 to enable)" >&2
  exit 0
fi

if command -v rustup >/dev/null 2>&1; then
  rustup default stable
  exit 0
fi

if [[ -x "$HOME/.cargo/bin/rustup" ]]; then
  "$HOME/.cargo/bin/rustup" default stable
  exit 0
fi

echo "rustup: not found; install Rust toolchain first (e.g. rustup-init)" >&2

