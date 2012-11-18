#!/bin/bash

echo -e "Initializing dev-station..."

function log {
  echo -e ">> $1"
}

export PATH=$PATH:$HOME/bin

PREV_DIR=$PWD
WORK_DIR=/tmp/dev-station-`date +%s`
mkdir -p $WORK_DIR
#cd $WORK_DIR

# Check before installing
log "Installing Homebrew ...."
ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"

log "Updating Homebrew ... "
brew update

log "Installing apple-gcc42"
brew tap homebrew/dupes
brew install apple-gcc42

log "Checking for RVM..."
if [ ! -d ~/.rvm ]; then
  log "RVM not found, installing..."
  curl -L https://get.rvm.io | bash -s stable
  source $HOME/.bash_profile
fi

if [[ ! $(rvm list | grep -F 1.9.2) ]]; then
  log "Installing ruby 1.9.2..."

  rvm install 1.9.2
fi

if [ ! $(which chef-solo 2>/dev/null) ]; then
  log "Installing chef gem..."
  rvm use 1.9.2 --default
  gem install chef --no-ri --no-rdoc >/dev/null || exit 1
fi