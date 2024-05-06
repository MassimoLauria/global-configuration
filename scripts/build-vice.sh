#!/bin/bash
#
# Copyright (C) 2021, 2024 by Massimo Lauria
#
# Created   : "2021-10-31, domenica 15:57 (CET) Massimo Lauria"
# Time-stamp: "2024-05-06, 11:33 (CEST) Massimo Lauria"
#
# Description::
#
# Build script for VICE
#

# Make shell more robust
# (see http://redsymbol.net/articles/unofficial-bash-strict-mode/#sourcing-nonconforming-document)
set -euo pipefail
IFS=$'\n\t'

# Code::
VERSION=vice-3.8
PREFIX=${HOME}/.local/
SRCDIR=${PREFIX}/src
BUILDOPTS="--enable-arch=native --with-resid --enable-native-gtk3ui --enable-ethernet --with-pulse --with-alsa --enable-vte --with-fast-sid --with-jpeg --enable-static-ffmpeg --enable-desktop-files --enable-x64"


# Download
if [ ! -s "${SRCDIR}/${VERSION}" ]; then
    cd ~/queue/
    wget -c https://sourceforge.net/projects/vice-emu/files/releases/${VERSION}.tar.gz/download -O ${VERSION}.tar.gz
    cd "${SRCDIR}"
    tar zfx "${HOME}/queue/${VERSION}.tar.gz"
fi

cd "${SRCDIR}/${VERSION}"
./configure "${BUILDOPTS}" --prefix="${PREFIX}"
make
make install

# Local Variables:
# fill-column: 80
# End:
