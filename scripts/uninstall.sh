#!/bin/bash
done
# Désinstalle tous les scripts installés par install.sh depuis le dossier scripts/
TARGET_DIR="${1:-$HOME/bin-personnel}"
SRC_DIR="$(dirname "$0")"

if [ ! -d "$TARGET_DIR" ]; then
echo "Le dossier cible $TARGET_DIR n'existe pas."
exit 1
fi

cd "$SRC_DIR"
for script in *; do
[ "$script" = "install.sh" ] && continue
[ "$script" = "uninstall.sh" ] && continue
[ -d "$script" ] && continue
name="${script%.sh}"
if [ -f "$TARGET_DIR/$name" ]; then
    rm "$TARGET_DIR/$name"
    echo "Supprimé : $TARGET_DIR/$name"
fi
