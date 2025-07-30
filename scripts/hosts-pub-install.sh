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

  echo "Exemple: sudo ./hosts-pub-install.sh"
  exit 0
fi
#!/bin/bash

# Linux hosts Installer for the Ultimate Hosts Blacklist
# Repo Url: https://github.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist
# Copyright (c) 2020 Ultimate Hosts Blacklist - @Ultimate-Hosts-Blacklist
# Copyright (c) 2017, 2018, 2019, 2020 Mitchell Krog - @mitchellkrogza
# Copyright (c) 2017, 2018, 2019, 2020 Nissar Chababy - @funilrys

#
# root has to run the script
#
if [[ $(id -u -n) != "root" ]]
    then
    printf "You need to be root to do this!\nIf you have SUDO installed, then run this script with `sudo ${0}`"
    exit 1
fi

# First Backup Existing hosts file
sudo mv /etc/hosts /etc/hosts.bak

# Now download the new hosts file and put it into place
sudo wget https://hosts.ubuntu101.co.za/hosts -O /etc/hosts

exit 0
