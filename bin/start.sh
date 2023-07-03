#!/bin/bash
set -e -x

echo "start.sh: installing doc"
bundle exec rdoc --all --ri --no-rdoc

echo "start.sh: starting server"
bundle exec rails server

echo "start.sh: this is fine"
