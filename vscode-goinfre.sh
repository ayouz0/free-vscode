#!/bin/bash

# This script redirects the Visual Studio Code cache to your goinfre directory.
# Useful for freeing space in your $HOME Library cache on 42's Macs.

USER_LOGIN=$(whoami)
GOINFRE_DIR="/goinfre/$USER_LOGIN/vscode_cache"
CACHE_DIR="$HOME/Library/Caches"

# Create main goinfre cache directory if missing
mkdir -p "$GOINFRE_DIR"

link_cache_folder() {
    local folder="$1"
    local cache_path="$CACHE_DIR/$folder"
    local goinfre_path="$GOINFRE_DIR/$folder"

    # Ensure goinfre subfolder exists
    mkdir -p "$goinfre_path"

    # If cache folder exists and is not a symlink → move and link
    if [ -d "$cache_path" ] && [ ! -L "$cache_path" ]; then
        echo "Moving existing cache: $folder"
        mv "$cache_path" "$goinfre_path"
        ln -s "$goinfre_path" "$cache_path"

    # If cache path is a symlink but wrong → fix it
    elif [ -L "$cache_path" ] && [ "$(readlink "$cache_path")" != "$goinfre_path" ]; then
        echo "Fixing wrong symlink: $folder"
        rm "$cache_path"
        ln -s "$goinfre_path" "$cache_path"

    # If cache path doesn’t exist at all → create symlink
    elif [ ! -e "$cache_path" ]; then
        echo "Creating symlink for missing cache: $folder"
        ln -s "$goinfre_path" "$cache_path"
    fi
}

# List of VS Code cache folders to redirect
folders=(
    "com.microsoft.VSCode"
    "com.microsoft.VSCode.ShipIt"
    "vscode-cpptools"
)

for f in "${folders[@]}"; do
    link_cache_folder "$f"
done

echo "✅ VS Code cache is now stored in: $GOINFRE_DIR"
