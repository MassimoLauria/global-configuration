#!/bin/bash

CFG=$HOME/config/python
PYENV_ROOT="$HOME/.pyenv"
PYENV_VERSION=3.12.4

echo "Installing basic python config files"
rm -f $HOME/.pythonrc.py
ln -s $CFG/pythonrc.py $HOME/.pythonrc.py
rm -f $HOME/.pdbrc
ln -s $CFG/pdbrc $HOME/.pdbrc


echo "Installing checker config files"
mkdir -p $HOME/.config/

rm -f $HOME/.pylintrc
ln -s $CFG/pylintrc $HOME/.pylintrc
rm -f $HOME/.config/flake8
ln -s $CFG/flake8 $HOME/.config/flake8

# Install pyenv if necessary
if [ ! -d $PYENV_ROOT ]; then
    echo "Pyenv not found: installing"
    git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT
    PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    echo "$(pyenv root)"
fi

# Install pyenv support for virtual environments
if [ ! -d $(pyenv root)/plugins/pyenv-virtualenv ];then
    git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
    eval "$(pyenv virtualenv-init -)"
fi

# Install pyenv support for updating
if [ ! -d $(pyenv root)/plugins/pyenv-update ];then
    git clone https://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-update
fi


# Update the system
pyenv update
echo "Maybe install release $PYENV_PYVERSION in pyenv"
yes n | pyenv install $ENV_PYVERSION
pyenv local $PYENV_VERSION

# Update pip and install all packages
python -m ensurepip --upgrade
python -m pip install -U pip
python -m pip install -U -r requirements.txt
