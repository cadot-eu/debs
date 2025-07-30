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

# Installe tous les scripts du dossier scripts/ dans ~/bin (ou dossier passé en argument)
TARGET_DIR="${1:-$HOME/bin}"
SRC_DIR="$(dirname "$0")/scripts"

if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
fi

for script in "$SRC_DIR"/*; do
    base="$(basename "$script")"
    [ "$base" = "install.sh" ] && continue
    [ "$base" = "uninstall.sh" ] && continue
    [ -d "$script" ] && continue
    name="${base%.sh}"
    cp "$script" "$TARGET_DIR/$name"
    chmod +x "$TARGET_DIR/$name"
    echo "Installé : $TARGET_DIR/$name"
done

# Vérifie et ajoute $TARGET_DIR au PATH si besoin
case ":$PATH:" in
    *:"$TARGET_DIR":*)
        echo "$TARGET_DIR est déjà dans le PATH."
    ;;
    *)
        echo "$TARGET_DIR n'est pas dans le PATH. Ajout automatique."
        if [ -n "$ZSH_VERSION" ]; then
            SHELL_RC="$HOME/.zshrc"
        else
            SHELL_RC="$HOME/.bashrc"
        fi
        if ! grep -q "export PATH=.*$TARGET_DIR" "$SHELL_RC" 2>/dev/null; then
            echo "export PATH=\"\$PATH:$TARGET_DIR\"" >> "$SHELL_RC"
        fi
        echo "Reload du shell ($SHELL_RC) pour prise en compte immédiate..."
        source "$SHELL_RC"
    ;;
esac

echo "Tous les scripts ont été installés dans $TARGET_DIR."