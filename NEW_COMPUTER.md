# New Mac setup (chezmoi-first)

This replaces the old “run `source bootstrap.sh`” flow. The goal is:

- **chezmoi** is the single source of truth for your dotfiles
- no `~/dotfiles` `rsync` bootstrap
- no **oh-my-zsh** (plain zsh + the few tools you actually use)

## 0) Before you start (manual)

- Sign into Apple ID/iCloud
- Install iTerm2 (if you want it before `brew bundle`)
- (Optional) Generate SSH keys and add them to GitHub

## 1) Install Apple command line tools

```sh
xcode-select --install
```

## 2) Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Initialize `brew` for the current shell session:

```sh
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
```

## 3) Install git + chezmoi

```sh
brew install git chezmoi
```

## 4) Bootstrap dotfiles from your chezmoi repo

Preferred (one-shot clone + apply):

```sh
chezmoi init --apply <YOUR_DOTFILES_REPO>
```

If you use SSH:

```sh
chezmoi init --apply --ssh <YOUR_DOTFILES_REPO>
```

Notes:

- The chezmoi source directory defaults to `~/.local/share/chezmoi`.
- Config defaults to `~/.config/chezmoi/chezmoi.toml`.
- If you have multiple Macs (e.g. Mac Studio + MacBook), use templates/conditionals so one repo can cover both.

## 5) Install packages/apps (Brewfile)

If your chezmoi repo includes a `Brewfile` (recommended), run:

```sh
brew bundle --global
```

If you keep it somewhere else (e.g. `~/.Brewfile`), run:

```sh
brew bundle --file ~/.Brewfile
```

## 6) Apply macOS defaults (optional)

“macOS defaults” means the `defaults write ...` / `pmset` / etc tweaks you previously had in `~/dotfiles/.macos`.

In the chezmoi flow, you keep these as an executable script inside your chezmoi repo under `.chezmoiscripts/`,
so they run during `chezmoi apply`.

Recommended approach:

- Create `~/.local/share/chezmoi/.chezmoiscripts/run_onchange_10_macos.sh` (runs when the script changes).
- Keep it **curated** and **idempotent**; add guards for app-specific settings.
- Avoid baking in deprecated apps (your old `.macos` had a lot of Spectacle config; skip or replace with whatever you actually use now).

Then run `chezmoi apply` and let chezmoi execute it:

```sh
chezmoi apply -v
```

Multi-Mac tip: keep “global” defaults in one script, and put host-specific tweaks behind hostname checks, e.g.:

```sh
if [ "$(scutil --get ComputerName 2>/dev/null)" = "YourMacStudioName" ]; then
  # studio-only tweaks
fi
```

## 7) Shell sanity checks (zsh, no oh-my-zsh)

Check your login shell:

```sh
dscl . -read /Users/$USER UserShell
```

Reload zsh as a login shell:

```sh
exec zsh -l
```

Verify the “daily drivers” exist (based on your history):

```sh
type gst gco gl la jn z gac gacp gdelete
```

## 8) Git identity

If not templated by chezmoi yet:

```sh
git config --global user.name "Junda"
git config --global user.email "junda@just2us.com"
```

## 9) What not to do anymore

- Don’t run `source ~/dotfiles/bootstrap.sh`.
- Don’t install/enable `~/.oh-my-zsh` for new machines.
