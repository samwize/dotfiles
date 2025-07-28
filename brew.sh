#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# JD: Install my apps
# Cask https://formulae.brew.sh/cask/
echo "Install Junda's Dev Apps"
brew install --cask iterm2
brew install --cask visual-studio-code
brew install --cask github
# brew install sourcetree
brew install figma
# brew install sketch
# brew install zeplin
# brew install fastlane
# brew install tunnelblick
brew install postman
brew install node
brew install --cask discord

echo "Install Junda's Productivity Apps"
# brew install skype
# brew install slack
# brew install evernote
# brew install spotify
brew install dropbox
brew install vlc
brew install google-chrome
brew install brave-browser
# brew install lastpass
# brew install transmission
brew install --cask rectangle
brew install skitch

echo "Install Junda's Personal Apps"
brew install whatsapp
# brew install youtube-dl
brew install ffmpeg
brew install exiftool
# brew install handbrake
# brew install libdvdcss
brew install folx

# Remove outdated versions from the cellar.
brew cleanup
