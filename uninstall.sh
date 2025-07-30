#!/bin/bash


# Option --reset pour supprimer les anciens scripts dans /bin
RESET=0
for arg in "$@"; do
    if [ "$arg" = "--reset" ]; then
        RESET=1
    fi
done

if [ $RESET -eq 1 ]; then
    LEGACY_BIN="/bin"
    SRC_DIR_LEGACY="$(dirname "$0")/scripts"
    for script in "$SRC_DIR_LEGACY"/*; do
        base="$(basename "$script")"
        name="${base%.sh}"
        if [ -f "$LEGACY_BIN/$name" ]; then
            sudo rm -f "$LEGACY_BIN/$name"
            echo "Ancien script supprimé de $LEGACY_BIN : $name"
        fi
    done
fi

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
        rm -f "$TARGET_DIR/$name"
        echo "Supprimé : $TARGET_DIR/$name"
    fi
done

    done
fi

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
        rm -f "$TARGET_DIR/$name"
        echo "Supprimé : $TARGET_DIR/$name"
    fi
done

