echo "Installing iOS Development Stuff"

npm install ios-sim -g

brew cask install fabric

# RVM and Ruby
# Use stable 2.3.4
\curl -sSL https://get.rvm.io | bash -s stable --ruby
rvm install 2.3.4

gem install cocoapods

# lolcommits
brew install imagemagick
gem install lolcommits
git config --global init.templatedir "$HOME/.git_template"
# Export of LOLCOMMITS_DIR in .zshrc
