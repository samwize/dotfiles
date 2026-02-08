# New Mac setup (chezmoi-first)

Goal: a consistent, boring, repeatable setup where:

- **chezmoi** is the single source of truth for dotfiles
- no legacy `~/dotfiles` `bootstrap.sh`/`rsync` flow
- no **oh-my-zsh** (plain zsh)

## 0) Before you start (manual)

- Sign into Apple ID/iCloud (if you use it)
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

## 4) Bootstrap dotfiles (review before applying)

```sh
chezmoi init --ssh <YOUR_DOTFILES_REPO>
chezmoi diff --exclude=scripts
chezmoi apply --exclude=scripts -v
exec zsh -l
```

## 5) Optional: run bootstrap installs/defaults

If your dotfiles repo includes `.chezmoiscripts/` (brew bundle, macOS defaults, etc.), run them only when you’re ready:

```sh
CHEZMOI_BOOTSTRAP=1 CHEZMOI_MACOS_DEFAULTS=1 \
  chezmoi apply --include=scripts -v
```

If you want to run scripts step-by-step during migration/refinement, follow `MIGRATING_TO_CHEZMOI.md`.
