# My dotfiles (forked from Mathias’s)

Dotfiles is great for setting up a new Mac.

All files (except those listed in `bootstrap.sh`) in this repository will be copied to your home directory when you run `source bootstrap.sh`. So feel free to add any "dotfiles" to this repository, except your password.

## Instructions for a new computer

#### 1. Install brew

```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

#### 2. Install git

```bash
brew install git
```

#### 3. Download dotfiles

```bash
cd ~
git clone https://github.com/samwize/dotfiles && cd dotfiles
```

#### 4. Auto setup with dotfiles

Inspect these files first: .bash_prompt, .exports, .aliases, .functions - it's your responsibility!

Once confirm run:

```bash
source bootstrap.sh
```

#### 5. Run these too

```bash
# Sensible OS X defaults
./.osx

# Install more brew stuff, cask install apps, and other apps
./brew.sh

# Install development apps, tools and setting them up
./setup-dev.sh
```

#### 6. Setup Oh-my-zsh

Setup [samwize's oh-my-zsh](https://github.com/samwize/oh-my-zsh).

```bash
git clone git://github.com/samwize/oh-my-zsh.git ~/.oh-my-zsh
cd ~
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s /bin/zsh
```

My zsh uses [agnoster](https://github.com/agnoster/agnoster-zsh-theme) theme, which requires Powerline font. In iTerm, go to Preferences > Profiles > Text > change font to a powerline supported font eg "Meslo LG M DZ for Powerline".

I have a preference for using [solarized](https://github.com/altercation/solarized) dark theme. In iTerm, you can change in Preferences > Profiles > Color > Color Presets

## Junda's Changes

### .osx

- Removed changes to: Computer name, Desktop configurations such as icon snap to grid, Notification bar, natural scroll, etc. Prefixed my comments with `JD:`


### .aliases

- Added `ws` for ~/Workspace


### Brew.sh

- Disable brew install which I don't always use

## Original dotfiles

My fork is based on [mathiasbynens](https://github.com/mathiasbynens/dotfiles).

There are [others](http://dotfiles.github.io).
