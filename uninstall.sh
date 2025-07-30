if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo -e "\nRestaure une sauvegarde duplicity."
    echo "Usage: restore [full|file|list] [fichier]"
    echo "Exemple: restore file monfichier.txt"
    exit 0
fi
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi
if [ -f .env.local ]; then
    export $(grep -v '^#' .env.local | xargs)
fi

if  [ -n "$BACKUP_URL" ]; then
    if [ -z $BACKUP_URL ]; then
        echo "no parameters "
    else
        case "$1" in
            full )
            duplicity restore $BACKUP_URL ./__restore --no-encryption ;;
            file )
                if [ -z "$2" ]
                then
                    echo "name of file?"
                else
                    DIR="$(dirname "${2}")" ;
                    mkdir -p "$DIR";
                    duplicity --file-to-restore "$2" $BACKUP_URL "$2"  --no-encryption
            fi;;
            list )
            duplicity list-current-files $BACKUP_URL ;;
            * )
            echo "get a parameter full,file or list" ;;
        esac
    fi
    
else
    echo "parameters empty in .env, get BACKUP_URL"
fi

  echo "  [dossier_cible] : dossier où supprimer les scripts (défaut: ~/bin)"
  echo "  --reset : supprime aussi les anciens scripts dans /bin (legacy)"
  echo "Exemple: ./uninstall.sh --reset"
  exit 0
fi
ALIASES=(
  "dlogs"
  "gcp"
  "killall:docker-kill-all"
  "dkillall:docker-kill-all"
  "dkill:docker-kill"
  "runsite:site-run"
  "runcaddy:caddy-run"
)
# Supprime les alias
for alias in "${ALIASES[@]}"; do
  src="${alias%%:*}"
  target="${alias##*:}"
  if [[ "$src" == "$target" ]]; then
    target="$src"
  fi
  [ -f "$TARGET_DIR/$src" ] && rm -f "$TARGET_DIR/$src"
done
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

