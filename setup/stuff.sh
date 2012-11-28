#!/bin/bash

# Installs Homebrew, Git, git-extras, git-friendly, Node.js, configures Apache, PHP, MySQL, etc.

# Ask for the administrator password upfront
sudo -v

# Install Homebrew
command -v brew >/dev/null 2>&1 || ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# GNU core utilities (those that come with OS X are outdated)
brew install coreutils
# GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# More recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep

# Git
brew install git
brew install git-extras
sudo bash < <( curl https://raw.github.com/jamiew/git-friendly/master/install.sh)

# MySQL
brew install mysql
unset TMPDIR
mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
/usr/local/opt/mysql/bin/mysqladmin -u root password 'root'

# Apache: enable PHP, .htaccess files, virtual hosts and set it to run as current user
cd /etc/apache2
sudo cp httpd.conf httpd.conf.bak
sudo cp extra/httpd-vhosts.conf extra/httpd-vhosts.conf.bak
sudo sed -i '' "s^#\(LoadModule php5_module\)^\1^" httpd.conf
sudo sed -i '' "s^#\(Include /private/etc/apache2/extra/httpd-vhosts.conf\)^\1^" httpd.conf
sudo sed -i '' "s^<IfDefine WEBSHARING_ON>^<IfDefine !0>^" httpd.conf
sudo sed -i '' "s^User _www^User `whoami`^" httpd.conf
sudo sed -i '' "s^Group _www^Group staff^" httpd.conf
echo -e "NameVirtualHost *:80\n\n<Directory />\n    AllowOverride All\n    Allow from all\n</Directory>\n" | sudo tee extra/httpd-vhosts.conf
cd -

# Everything else
brew install unrar

# Node.js
brew install node
brew install casperjs
npm install -g grunt
npm install -g jshint
npm install -g bower

# Python
sudo pip install fabric

# Remove outdated versions from the cellar
brew cleanup
