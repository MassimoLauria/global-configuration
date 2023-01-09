#!/bin/bash

# List of packages to install
Packages="
autopep8
black
cffi
cnfgen
gdbgui
ipython
jc
jedi
jq
jupyter
jupyterlab
keras
keyring
manim
matplotlib
mxnet
mypy
mypy-extensions
networkx
notebook
numpy
pandas
Pillow-SIMD
pinboard
pybind11
Pygments
pylint
pyparsing
python-sat
python-lsp-server[all]
qiskit
rich
scipy
seaborn
Sphinx
sphinx-rtd-theme
sympy
tensorflow
torch
tornado
thonny
urllib3
yapf
youtube-dl
z3-solver"

CFG=$HOME/config/python
PYENV_ROOT="$HOME/.pyenv"


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

if [ ! -d $PYENV_ROOT ]; then
    echo "Pyenv not found: installing"
    git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT
    PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    echo "$(pyenv root)"
    git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
    eval "$(pyenv virtualenv-init -)"
    git clone https://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-update
else
    pyenv update
fi

PYENV_PYVERSION=$(pyenv install -l | grep '[[:space:]]3.[[:digit:]]*.[[:digit:]]*$' | grep -v 'rc\|dev' | tail -1)
echo "Maybe install release $PYENV_PYVERSION in pyenv"
yes n | pyenv install $PYENV_PYVERSION
pyenv global $PYENV_PYVERSION

# Update pip and install all packages
pip install -U pip
pip install ${Packages}
