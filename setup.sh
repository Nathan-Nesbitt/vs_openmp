#!/bin/bash

# Script that installs the requirements inside of WSL and sets up VSCode
# this will require a sudo password to install the binaries for the system.

# Setup VSCode
declare -a requirements=("ms-vscode-remote.remote-wsl" "ms-vscode.cpptools")

# If we are working in WSL
code_install="code"

# Absolutely nuts solution for handling backslashes in WSL (^ = escape for space in CMD)
if cat /proc/version | grep Microsoft; then
    user_path=$(echo $(wslvar USERPROFILE) | sed 's/\\/\\\\/g')
    code_install="cmd.exe /c "$user_path"\\AppData\\Local\\Programs\\Microsoft^ VS^ Code\\bin\\code"
fi
for i in ${requirements[@]}; do
    echo $i
    $code_install --install-extension $i
done

# Install build requirements
sudo apt -y update
sudo apt -y upgrade

sudo apt install -y build-essential gdb

# Run VSCode in WSL with current directory
current_dir=${PWD##*/}
code -n ../$current_dir
