# chezmoi draft (review before applying)

This folder contains a **draft chezmoi source tree** (what would normally live in `~/.local/share/chezmoi/`).

It is checked into this repo so you can review the proposed “plain zsh + curated git + Brewfile + scripts” setup
before copying it into your actual chezmoi repo.

Canonical step-by-step plan: `../MIGRATING_TO_CHEZMOI.md`.

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

Review + execution instructions live in `../MIGRATING_TO_CHEZMOI.md`.
