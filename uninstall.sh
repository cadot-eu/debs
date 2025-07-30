
#!/bin/bash

set -e

usage() {
    echo -e "\nDésinstalle les scripts installés par install.sh."
    echo "Usage: $0 [dossier_cible] [--reset]"
    echo "  [dossier_cible] : dossier où supprimer les scripts (défaut: ~/bin)"
    echo "  --reset : supprime aussi les anciens scripts dans /bin (legacy)"
    echo "Exemple: ./uninstall.sh --reset"
    exit 0
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

# Gestion des options
RESET=0
TARGET_DIR=""
for arg in "$@"; do
    if [ "$arg" = "--reset" ]; then
        RESET=1
        elif [ -z "$TARGET_DIR" ]; then
        TARGET_DIR="$arg"
    fi
done
TARGET_DIR="${TARGET_DIR:-$HOME/bin}"
SRC_DIR="$(dirname "$0")"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Le dossier cible $TARGET_DIR n'existe pas."
    exit 1
fi

# Supprime les alias (liens symboliques)
ALIASES=(
    "dlogs"
    "gcp"
    "killall:docker-kill-all"
    "dkillall:docker-kill-all"
    "dkill:docker-kill"
    "runsite:site-run"
    "runcaddy:caddy-run"
)
for alias in "${ALIASES[@]}"; do
    src="${alias%%:*}"
    target="${alias##*:}"
    if [[ "$src" == "$target" ]]; then
        target="$src"
    fi
    [ -f "$TARGET_DIR/$src" ] && rm -f "$TARGET_DIR/$src"
done

# Option --reset pour supprimer les anciens scripts dans /bin
if [ $RESET -eq 1 ]; then
    LEGACY_BIN="/bin"
    SRC_DIR_LEGACY="$SRC_DIR/scripts"
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
cd "$SRC_DIR/scripts"
for script in *; do
    [ -d "$script" ] && continue
    name="${script%.sh}"
    if [ -f "$TARGET_DIR/$name" ]; then
        rm -f "$TARGET_DIR/$name"
        echo "Supprimé : $TARGET_DIR/$name"
    fi
done


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
for arg in "$@"; do
    if [[ "$arg" != "--reset" ]]; then
        TARGET_DIR="$arg"
        break
    fi
done
TARGET_DIR="${TARGET_DIR:-$HOME/bin}"
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

