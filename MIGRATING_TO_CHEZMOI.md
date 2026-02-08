# Migrating off `~/dotfiles` *and* oh-my-zsh to chezmoi (single source of truth)

Goal: **deprecate both**:

- this repo’s `bootstrap.sh`/`rsync` dotfiles flow
- `~/.oh-my-zsh` (and any oh-my-zsh-managed plugins/themes)

…and end up with **plain zsh config managed by chezmoi**, containing only what you actually use today.

## What is “enabled” today (high level)

This repo is an older “copy everything into `$HOME`” style setup. Running `source bootstrap.sh` copied repo files into `~` and then sourced `~/.bash_profile`.

Your current day-to-day shell config is **zsh**, and it is primarily driven by files in `~`:

- `~/.zshenv` (runs for *every* zsh invocation)
- `~/.zprofile` (login shells)
- `~/.zshrc` (interactive shells)
- `~/.zlogin` (login hook)

Historically, oh-my-zsh has been “enabled” by `~/.zshrc` containing `source $ZSH/oh-my-zsh.sh`.

## Migration plan (minimal disruption, maximum pruning)

### Phase 0 — Freeze (optional snapshot)

1) Stop running `bootstrap.sh` from this repo.
2) Optional but still recommended if you’re about to do big shell edits: make a quick local snapshot so you can recover from a broken shell config.

```sh
mkdir -p ~/dotfiles-migration-backup
cp -a ~/.zshenv ~/.zprofile ~/.zshrc ~/.zlogin ~/dotfiles-migration-backup/ 2>/dev/null || true
```

If you plan to delete oh-my-zsh later, snapshot it too (optional):

```sh
cp -a ~/.oh-my-zsh ~/dotfiles-migration-backup/ 2>/dev/null || true
```

### Phase 1 — Audit what you *actually* use

You can’t prune safely without an audit.

1) Identify your most-used commands (helps decide which aliases/functions to keep).

```sh
awk '/^: [0-9]+:[0-9]+;/{line=$0; sub(/^: [0-9]+:[0-9]+;/,"",line); print line}' ~/.zsh_history \
  | awk '{print $1}' | sort | uniq -c | sort -nr | head -30
```

2) List what your current shell defines (so you can re-create only the useful subset):

```sh
zsh -lic 'echo "PATH=$PATH"; echo; alias | head -50'
```

3) Make a “keep / drop” list from your current `~/.zshrc`:

- **Keep**: things you can explain why you need (tool init, PATH entries, env vars you rely on).
- **Drop**: historical PATH clutter, unused SDK blocks, old editors (Atom), old tools (Spectacle), Python 2-era helpers, etc.

#### What your history suggests you should preserve

From your `~/.zsh_history`, the “muscle memory” commands worth keeping are:

- Git: `gst`, `gco`, `gl`, plus your custom `gac`/`gacp`
- Navigation: `la`, `..`, and a `z`-style directory jumper
- Journaling: `jn` (currently `journal new -d`)
- Tooling you call directly (not shell-specific): `pnpm`, `npm`, `npx`, `brew`, `fastlane`, `jekyll`, `yt-dlp`, `ffmpeg`

Current definitions (as seen in an interactive login zsh):

```sh
gst='git status'
gco='git checkout'
gl='git pull'
la='ls -lAh'
jn='journal new -d'

gac()  { git add . && git commit -a -m "$1" }
gacp() { git add . && git commit -a -m "$1" && git push }
gdelete() { git branch --delete "$1" && git push origin --delete "$1" }
```

### Phase 2 — Choose replacements for oh-my-zsh features

Replace only what you miss after removing oh-my-zsh. A practical baseline:

- Prompt/theme: use `starship` (or another prompt) instead of an oh-my-zsh theme.
- Directory jumping: replace oh-my-zsh `z` plugin with `zoxide`.
- Git aliases: define your own small set in your zsh config (e.g. `gst`, `gco`, `gl`, plus your `gac`/`gacp` functions).
- Completion: use native zsh completion (`compinit`) and optionally install extra completions via Homebrew (`zsh-completions`) if needed.

#### Known “noise” to remove while you’re here

When running `zsh -lic ...`, your current init prints warnings/errors:

- `nvm` warns about npm’s `prefix` being `/opt/homebrew` (common when you’re actually using Homebrew’s Node).
- `pyenv` reports shims not writable (your `~/.pyenv/shims` contains root-owned files).

The migration is a good time to pick one Node strategy (Homebrew *or* a version manager) and fix pyenv ownership if you still use it.

### Phase 3 — Initialize chezmoi and import *current* truth

Important: your `~` copies have drifted from this repo, so import from `~`, not `~/dotfiles`.

```sh
chezmoi init
chezmoi add ~/.zshenv ~/.zprofile ~/.zshrc ~/.zlogin
chezmoi add ~/.gitconfig
```

Optional:

```sh
chezmoi add ~/.curlrc ~/.editorconfig
```

### Phase 4 — Refactor into “plain zsh” (remove oh-my-zsh)

In your chezmoi-managed `~/.zshrc`:

1) Remove (or comment) these:

- `export ZSH=...`
- `plugins=(...)`
- `source $ZSH/oh-my-zsh.sh`

2) Add a minimal zsh baseline:

- `autoload -Uz compinit && compinit`
- prompt init (e.g. starship)
- source small, local files for aliases/functions if you prefer modular config

3) Port only the custom pieces you actually use:

- from oh-my-zsh git plugin: define your own `gst`, `gco`, `gl`, etc.
- from your custom plugin: keep `gac`, `gacp`, `gdelete` if you still use them
- from old dotfiles: keep `la`, `..`, etc *only if you still use them*

#### Replace `z` plugin (keep the `z` command)

oh-my-zsh currently provides `z` via its `z` plugin (you effectively have `z='_z 2>&1'`).

With `zoxide`, you still keep the `z` command, but without oh-my-zsh:

```sh
brew install zoxide
# in ~/.zshrc
eval "$(zoxide init zsh)"
```

#### Suggested “plain zsh” baseline (chezmoi source)

If you want to go all-in on chezmoi, a clean starting point is to manage these in your chezmoi source as:

- `dot_zshenv` → `~/.zshenv`
- `dot_zprofile` → `~/.zprofile`
- `dot_zshrc` → `~/.zshrc`

Example `~/.zshrc` (keep it small; add only when you miss something):

```sh
# Completion
autoload -Uz compinit && compinit

# Prompt (optional)
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# Directory jumping (replaces oh-my-zsh z)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# Common aliases you actually use
alias gst='git status'
alias gco='git checkout'
alias gl='git pull'
alias la='ls -lAh'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias jn='journal new -d'

# Your custom git helpers
gac()  { git add . && git commit -a -m "$1" }
gacp() { git add . && git commit -a -m "$1" && git push }
gdelete() { git branch --delete "$1" && git push origin --delete "$1" }
```

Then install only the tools you chose:

```sh
brew install starship zoxide
```

### Phase 5 — Move “setup scripts” into chezmoi patterns

This repo’s one-shot scripts are a mix of outdated and machine-specific. With chezmoi:

- Homebrew installs: move to `Brewfile` + a `run_once_...` script that runs `brew bundle`.
- macOS defaults: keep a curated subset (not the whole `.macos`) in a `run_onchange_...` script.

### Phase 6 — Cutover and verify

```sh
chezmoi diff
chezmoi apply -v
exec zsh -l
```

Verify:

- prompt renders correctly
- completions work (`git <TAB>`, etc.)
- your most-used aliases still exist (`gst`, `gco`, `gl`, `la`, `jn`, `z` replacement, etc.)

### Phase 7 — Deprecate and remove the old systems

1) Deprecate `~/dotfiles`:

- don’t run `bootstrap.sh` anymore
- archive the repo or keep it as historical reference

2) Deprecate oh-my-zsh:

- once you’ve run for a few days without issues:

```sh
mv ~/.oh-my-zsh ~/.oh-my-zsh.bak
```

- if everything is stable after another few days/weeks, delete the backup.

## Two-machine setup (Mac Studio “main” + MacBook “secondary”)

Recommended order:

1) Build the baseline on your Mac Studio (the “main” machine): plain zsh + core tooling.
2) Apply on the MacBook, then add *only* laptop-specific differences (battery/power, Dock/hot corners if you care, etc.).

In chezmoi templates, prefer host-conditional config rather than forking everything:

- Use `{{ .chezmoi.hostname }}` for host-specific sections.
- Use `{{ if eq .chezmoi.hostname "..." }}` blocks in templates for small diffs.
- For larger diffs, keep host-specific files like `dot_config/.../something.<hostname>.tmpl` and include them conditionally from a common file.
