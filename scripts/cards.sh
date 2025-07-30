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

  echo "Exemple: cards.sh"
  exit 0
fi
#!/bin/bash
my_dir="$(dirname "$0")"
source "$my_dir/lib.sh"
# ---------------------------------------------------------------------------- #

docker exec -i mariadb mysql -uroot -D nextcloud -parowana <<EOF
INSERT INTO oc_deck_cards (\`id\`, \`title\`, \`description\`, \`description_prev\`, \`stack_id\`, \`type\`, \`last_modified\`, \`last_editor\`, \`created_at\`, \`owner\`, \`order\`, \`archived\`, \`duedate\`, \`notified\`, \`deleted_at\`) VALUES (NULL, "tests", "", "", "125", "plain", "1675253824", "mickadmin", "1675253792", "mickadmin", "2000", "0", NULL, "0", "0");
EOF
