echo "Installing iOS Development Stuff"

sudo gem install cocoapods

npm install ios-sim -g

brew cask install fabric

# RVM and Ruby
# Use stable 2.3.4
\curl -sSL https://get.rvm.io | bash -s stable --ruby
rvm install 2.3.4

# lolcommits
brew install imagemagick
gem install lolcommits
git config --global init.templatedir "$HOME/.git_template"
export LOLCOMMITS_DIR="$HOME/Pictures/lolcommits"
