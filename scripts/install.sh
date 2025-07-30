#!/bin/bash
# Installe tous les scripts du dossier scripts/ dans ~/bin-personnel (ou dossier passé en argument)
TARGET_DIR="${1:-$HOME/bin-personnel}"
SRC_DIR="$(dirname "$0")"

if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
fi

cd "$SRC_DIR"
for script in *; do
    [ "$script" = "install.sh" ] && continue
    [ "$script" = "uninstall.sh" ] && continue
    [ -d "$script" ] && continue
    name="${script%.sh}"
    cp "$script" "$TARGET_DIR/$name"
    chmod +x "$TARGET_DIR/$name"
    echo "Installé : $TARGET_DIR/$name"
