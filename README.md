# My dotfiles (forked from Mathias’s)

Dotfiles is great for setting up a new Mac.

All files (excluding those listed in `bootstrap.sh`) will be copied to your home directory when you run `source bootstrap.sh`. So feel free to add any "dotfiles" to this repository, except your password.

## Backup old computer

```bash
# Backup Atom's community packages installed
apm list --installed --bare > ~/dotfiles/backup/atom/package-list.txt

# Backup Xcode Keybindings.. todo
```

SENSITIVE stuff that has to be backup using external hard drive:

    # Example:
    cp ~/.3T/robo-3t/1.2.1/robo3t.json /BACKUP/DRIVE/

Time Machine back up and restore can be used. But unreliable with incomplete restoration possible, eg. when Migration Assistant encounter file write error.

## Instructions for a new computer

### 1. Install brew

```bash
# https://brew.sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install git

```bash
brew install git
```

### 3. Download dotfiles

```bash
cd ~
git clone https://github.com/samwize/dotfiles && cd dotfiles
```

### 4. Auto setup with dotfiles

Inspect these files first: .bash_prompt, .exports, .aliases, .functions - it's your responsibility!

Once confirmed all good, run:

```bash
source bootstrap.sh
```

Or, run rsync yourself. It copies those dotfiles to your home.

### 5. Install apps, configure mac

```bash
# Install more brew stuff and apps
./brew.sh

# Install development apps, tools and setting them up
./setup-dev.sh

# Sensible macOS defaults
./.macos
```

### 6. Setup Oh-my-zsh

Setup [samwize's oh-my-zsh](https://github.com/samwize/oh-my-zsh).

```bash
git clone https://github.com/samwize/oh-my-zsh ~/.oh-my-zsh
cd ~
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
chsh -s /bin/zsh
```

My zsh uses [agnoster](https://github.com/agnoster/agnoster-zsh-theme) theme, which requires Powerline font. In iTerm, go to Preferences > Profiles > Text > change font to eg "Meslo LG M DZ for Powerline" ([download](https://github.com/powerline/fonts/blob/master/Meslo%20Dotted/Meslo%20LG%20M%20DZ%20Regular%20for%20Powerline.ttf) and install).

I have a preference for using [solarized](https://github.com/altercation/solarized) dark theme. In iTerm, you can change in Preferences > Profiles > Color > Color Presets

### 7. Other Manual Configurations

- Enable [drag with 3 fingers](https://support.apple.com/en-sg/HT204609) under Accessibility > Mouse & Trackpad > Trackpad Options
- Install [NVM](https://github.com/nvm-sh/nvm) and `nvm install --lts`
- `npm install -g @anthropic-ai/claude-code`
- `sudo scutil --set ComputerName "DaMachineName"`
- `sudo scutil --set HostName "DaMachineName"`
- `sudo scutil --set LocalHostName "DaMachineName"`

## Junda's Changes

My fork is based on [mathiasbynens](https://github.com/mathiasbynens/dotfiles) (the original dotfiles). There are [others](http://dotfiles.github.io)

- `.osx`: Removed changes to: Computer name, Desktop configurations such as icon snap to grid, Notification bar, natural scroll, etc. Prefixed my comments with `JD:`
- `.aliases`: Added for my productivity
- `Brew.sh`: Disable brew install which I don't always use
