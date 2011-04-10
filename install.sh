#!/bin/sh
if [ $# -ge 1 ]; then
    directory=$1
else
    directory=$HOME
fi

_files="_*"
for _file in ${_files}; do
    dotfile=$(echo $_file | sed -e "s/_/./")
    ln -s $(pwd -P)/$_file $directory/$dotfile
    echo "link $_file to $directory/$dotfile"
done
