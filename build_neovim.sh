#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Usage:" $0 "<neovim_repo_dir>"
	exit 1
fi
cd $1
if [ "$?" -ne 0 ]; then
	echo "Failed to cd" $1
	exit 1
fi
rm -Rf ./build
make clean
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$HOME/neovim" CMAKE_BUILD_TYPE=Release
make install
