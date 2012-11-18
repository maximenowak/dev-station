#!/bin/bash

echo -e "Initializing dev-station..."

function log {
  echo -e ">> $1"
}

export PATH=$PATH:$HOME/bin

PREV_DIR=$PWD
WORK_DIR=/tmp/dev-station-`date +%s`
mkdir -p $WORK_DIR
cd $WORK_DIR


log "Checking for RVM..."
if [ ! -d ~/.rvm ]; then
  log "RVM not found, installing..."
  curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer -o rvm-installer && chmod +x rvm-installer && ./rvm-installer --version latest || exit 1

  log "Appending RVM function to your .bash_profile..."
  grep "scripts/rvm" ~/.bash_profile >/dev/null 2>&1 || echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function' >> ~/.bash_profile
  . ~/.rvm/scripts/rvm
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