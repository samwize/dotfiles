# chezmoi draft (review before applying)

This folder contains a **draft chezmoi source tree** (what would normally live in `~/.local/share/chezmoi/`).

It is checked into this repo so you can review the proposed “plain zsh + curated git + Brewfile + scripts” setup
before copying it into your actual chezmoi repo.

## What’s inside

- `dot_zshenv`, `dot_zprofile`, `dot_zshrc`, `dot_zlogin`: plain zsh (no oh-my-zsh)
- `dot_config/zsh/*`: modular zsh config (aliases/functions/env + per-host overrides)
- `dot_gitconfig`: git config with:
  - removed `commit.template` (`~/.stCommitMsg` legacy)
  - removed `core.attributesfile` (your `~/.gitattributes` is currently no-op)
  - moved global ignore to `~/.config/git/ignore`
- `dot_config/git/ignore`: global gitignore (`*~`, `.DS_Store`)
- `Brewfile`: baseline Homebrew packages/apps (intended to be dumped+curated from DaStudio later)
- `.chezmoiscripts/*`: idempotent hooks for:
  - `brew bundle`
  - Ruby gems (for `journal` → `jn`)
  - cargo tools
  - optional npm global installs
  - curated macOS defaults
- `dot_config/bootstrap/*`: the “non-brew” install lists (`gems.txt`, `cargo.txt`, `npm-global.txt`)
- `NEW_COMPUTER.md`: the bootstrap commands for a new Mac (chezmoi-first)

## Safety toggles

The scripts do nothing unless enabled via env vars:

- `CHEZMOI_BOOTSTRAP=1` enables `brew bundle` + gem/cargo/npm install scripts
- `CHEZMOI_MACOS_DEFAULTS=1` enables the macOS defaults script

## Known placeholders / things to review

- `dot_config/bootstrap/npm-global.txt` currently includes `meteorite` as a placeholder because it’s frequently used in history,
  but it’s not a Homebrew formula. Decide if you want to keep it as an `npm -g` install or remove it.
- `dot_config/bootstrap/cargo.txt` is minimal and currently includes `ore-hq-client`; adjust to match what you want available everywhere.
- Node toolchain: this draft assumes Homebrew `node`/`pnpm` (not `proto`, not `nvm`).
- macOS defaults: only a curated subset is included; add/remove as desired and keep app-specific defaults out unless you truly use them.

## How to use this after review

Option A (recommended): copy into your chezmoi repo (e.g. `~/.local/share/chezmoi/`) and then:

```sh
chezmoi diff
chezmoi apply -v
```

Option B: cherry-pick individual files into your existing chezmoi repo.

