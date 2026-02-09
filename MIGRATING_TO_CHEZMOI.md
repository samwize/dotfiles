# Chezmoi migration (audit-first)

This document covers migrating this machine off this repo’s legacy `bootstrap.sh`/`rsync` flow and off `~/.oh-my-zsh`, and ending up with a **plain zsh** setup managed by **chezmoi**.

For setting up a brand new Mac going forward, use `NEW_COMPUTER.md`.

This repo also includes a reviewed starting point at `chezmoi-draft/` (a draft chezmoi source tree).

## Success criteria

- `chezmoi diff` is clean after `chezmoi apply`.
- A fresh `exec zsh -l` works (no oh-my-zsh).
- Only the aliases/functions/env you actually use are kept.
- “Bootstrap installs” (Homebrew bundle, gems, cargo tools, npm globals, macOS defaults) are *intentional*, not accidental.

## Important: keep scripts off until you’re ready

The draft includes `.chezmoiscripts/` hooks (brew bundle, macOS defaults, etc).

While migrating, apply dotfiles without executing scripts:

```sh
chezmoi diff --exclude=scripts
chezmoi apply --exclude=scripts -v
```

Then, only when you’ve reviewed the lists/scripts, run them explicitly (see “Bootstrap installs” below).

## 0) Freeze + snapshot (recommended)

Stop running `source ~/dotfiles/bootstrap.sh`.

Make a quick rollback copy of your current shell config:

```sh
mkdir -p ~/dotfiles-migration-backup
cp -a ~/.zshenv ~/.zprofile ~/.zshrc ~/.zlogin ~/dotfiles-migration-backup/ 2>/dev/null || true
cp -a ~/.gitconfig ~/dotfiles-migration-backup/ 2>/dev/null || true
```

## 1) Audit (Marie Kondo pass)

Goal: identify what actually supports your day-to-day work, and ditch the rest.

Identify your most-used commands (helps prune aliases/functions/env):

```sh
(export LC_ALL=C LANG=C
  awk '/^: [0-9]+:[0-9]+;/{line=$0; sub(/^: [0-9]+:[0-9]+;/,"",line); print line}' ~/.zsh_history \
    | awk '{print $1}' | sort | uniq -c | sort -nr | head -30
)
```

Inspect what your current interactive login zsh defines:

```sh
zsh -lic 'echo "PATH=$PATH"; echo; alias | head -80'
```

Dump the “shape” of your current shell (useful before you start deleting):

```sh
zsh -lic 'echo; echo "path entries:"; print -l $path | sed -n "1,120p"; echo; echo "function names:"; print -l ${(k)functions} | sort | sed -n "1,120p"'
```

Now write down a short keep list:

- Shell “muscle memory” aliases you type daily
- Any PATH/env additions you can justify
- Any functions you actually call (or that save you time)
- Any completions/prompt/directory jumping you would miss immediately

Everything else: delete it until you miss it. If it doesn’t spark joy, it doesn’t make the cut.

## 2) Start from `chezmoi-draft/` (minimal baseline)

`chezmoi-draft/` is a proposed minimal baseline:

- plain zsh (`dot_zsh*` + `dot_config/zsh/*`)
- curated git config + global ignore
- a baseline Brewfile
- optional bootstrap scripts under `.chezmoiscripts/`

Before copying, prune it so it matches what you actually use:

- `chezmoi-draft/Brewfile` (remove unused casks/formulae)
- `chezmoi-draft/dot_config/zsh/env.zsh` (remove unused PATH blocks)
- `chezmoi-draft/dot_config/bootstrap/*` (remove placeholders you don’t use, e.g. `ore-hq-client`)
- `chezmoi-draft/.chezmoiscripts/*` (review anything that runs `sudo` / touches system defaults)

Copy the draft into your real chezmoi source directory:

```sh
chezmoi cd
# (in another terminal, from this dotfiles repo root)
rsync -a chezmoi-draft/ ~/.local/share/chezmoi/
```

Notes:

- If `~/.local/share/chezmoi` already exists, back it up first.
- `rsync -a` preserves executable bits for `.chezmoiscripts/`.

If you find something in `~` that still sparks joy later, add it deliberately:

```sh
chezmoi add ~/.some-file
```

## 3) Cut over on this machine (dotfiles only)

Preview changes without executing scripts:

```sh
chezmoi diff --exclude=scripts
```

Apply (still no scripts):

```sh
chezmoi apply --exclude=scripts -v
exec zsh -l
```

## 4) Verify (plain zsh, no oh-my-zsh)

Confirm you’re not sourcing oh-my-zsh anymore:

- `~/.zshrc` should not contain `source $ZSH/oh-my-zsh.sh`.

Verify your daily drivers exist:

```sh
type gst gco gl la jn z gac gacp gdelete
```

If something is missing, add it back deliberately in the modular files:

- `~/.config/zsh/aliases.zsh`
- `~/.config/zsh/functions.zsh`
- `~/.config/zsh/env.zsh`
- `~/.config/zsh/hosts/<hostname>.zsh` (host-only tweaks)

## 5) Bootstrap installs (optional, run intentionally)

The draft includes:

- Homebrew bundle (`.chezmoiscripts/run_once_20_brew_bundle.sh` + `Brewfile`)
- Ruby gems (`journal`) via `~/.config/bootstrap/gems.txt`
- cargo tools via `~/.config/bootstrap/cargo.txt`
- npm globals via `~/.config/bootstrap/npm-global.txt`
- curated macOS defaults (`.chezmoiscripts/run_onchange_10_macos_defaults.sh`)

Two safe ways to run these step-by-step:

### A) Run the scripts manually (recommended during migration)

This avoids any “run once” state surprises and lets you run only what you want:

```sh
chezmoi cd
CHEZMOI_BOOTSTRAP=1 ./.chezmoiscripts/run_once_20_brew_bundle.sh
CHEZMOI_BOOTSTRAP=1 ./.chezmoiscripts/run_once_30_ruby_gems.sh
CHEZMOI_BOOTSTRAP=1 ./.chezmoiscripts/run_once_35_rustup.sh
CHEZMOI_BOOTSTRAP=1 ./.chezmoiscripts/run_once_40_cargo_tools.sh
CHEZMOI_BOOTSTRAP=1 ./.chezmoiscripts/run_once_50_npm_global.sh
CHEZMOI_MACOS_DEFAULTS=1 ./.chezmoiscripts/run_onchange_10_macos_defaults.sh
```

### B) Let chezmoi execute scripts (only when you’re ready)

Only do this once you’ve curated the Brewfile/lists and you’re ready for *all* enabled scripts:

```sh
CHEZMOI_BOOTSTRAP=1 CHEZMOI_MACOS_DEFAULTS=1 \
  chezmoi apply --include=scripts -v
```

If you run `chezmoi apply --include=scripts` without the env vars, the scripts will “skip” but still be considered run by chezmoi (since they exit successfully).

## 6) Deprecate the old systems (after a few days)

Once you’ve had a stable shell for a few days:

- Archive this repo’s legacy flow: don’t run `bootstrap.sh` anymore.
- Disable oh-my-zsh:

```sh
mv ~/.oh-my-zsh ~/.oh-my-zsh.bak
```

If everything stays stable, delete the backup later.

## New Mac setup

See `NEW_COMPUTER.md`.

## Two-machine setup (main + secondary)

Prefer one repo with small host-specific diffs:

- Put shared config in `~/.config/zsh/*.zsh`.
- Put host-specific tweaks in `~/.config/zsh/hosts/<hostname>.zsh`.
- For templates, use `.chezmoi.hostname` and conditionals.
