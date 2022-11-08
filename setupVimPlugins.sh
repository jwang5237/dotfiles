#!/bin/bash

set -e

### To install your vim plugins, install the plugin manager using the following curl
### command.  After the installation open a file (any file will do) with vim, 
### and issue the command:
### :PlugInstall
curl -k -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
