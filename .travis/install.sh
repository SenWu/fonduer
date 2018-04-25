#!/bin/bash

env

# Print all commands before executing
set -v

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
  brew install python3
  virtualenv venv -p python3
  source venv/bin/activate
  brew install poppler
else
  # Install some custom requirements on Linux
  wget poppler.freedesktop.org/poppler-0.53.0.tar.xz
  tar -xf ./poppler-0.53.0.tar.xz
  cd poppler-0.53.0
  ./configure
  make
  sudo checkinstall -y
  dpkg -L poppler-utils
  cd ..
  export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
  echo "Using LD_LIBRARY_PATH=${LD_LIBRARY_PATH}"
fi

pip install coveralls
pip install flake8
make dev
python -m spacy download en
