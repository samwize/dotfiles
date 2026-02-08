# New Mac setup (chezmoi-first)

Goal: consistent setup across DaStudio (main) and DaGoldMac (secondary), with:

- chezmoi as the single source of truth
- no legacy `~/dotfiles` rsync bootstrap
- no oh-my-zsh (plain zsh)

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

## 4) Bootstrap dotfiles

```sh
CHEZMOI_BOOTSTRAP=1 CHEZMOI_MACOS_DEFAULTS=1 \
  chezmoi init --apply --ssh git@github.com:samwize/dotfiles2.git
```

Notes:

- `CHEZMOI_BOOTSTRAP=1` enables brew bundle + gem/cargo/npm installs via `.chezmoiscripts/`.
- `CHEZMOI_MACOS_DEFAULTS=1` enables curated macOS defaults.

## 5) Manual logins (by design)

- `gh auth login`
- Any other CLI auth you need (gcloud/aws/etc.)

## 6) Sanity checks

```sh
exec zsh -l
type gst gco gl la jn z gac gacp gdelete
git config --global --get commit.template || true
```

