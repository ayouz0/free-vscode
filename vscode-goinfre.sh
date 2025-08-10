#!/bin/bash

#this script is to make visual studio code cache be redirected to your sgoinfre

USER_LOGIN=$(whoami)

GOINFRE_DIR="/goinfre/$USER_LOGIN/vscode_cache"
CACHE_DIR="$HOME/Library/Caches"

mkdir -p "$GOINFRE_DIR"

link_cache_folder() {
    local folder="$1"
    if [ -d "$CACHE_DIR/$folder" ] && [ ! -L "$CACHE_DIR/$folder" ]; then
        mv "$CACHE_DIR/$folder" "$GOINFRE_DIR/$folder"#moving your existant cache
        ln -s "$GOINFRE_DIR/$folder" "$CACHE_DIR/$folder"
    elif [ ! -e "$CACHE_DIR/$folder" ]; then
        ln -s "$GOINFRE_DIR/$folder" "$CACHE_DIR/$folder"
    fi
}

link_cache_folder "com.microsoft.VSCode"
link_cache_folder "com.microsoft.VSCode.ShipIt"
link_cache_folder "vscode-cpptools"

echo "vs code cashe is now at $GOINFRE_DIR"
