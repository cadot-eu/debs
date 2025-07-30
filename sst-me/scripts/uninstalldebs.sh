#!/bin/bash
# Désinstalle les paquets listés dans un fichier ou en argument
if [ -z "$1" ]; then
    echo "Usage: $0 <fichier_liste_debs>"
    exit 1
fi

while read -r pkg; do
    if [ -n "$pkg" ]; then
        echo "Suppression de $pkg ..."
        sudo apt-get remove --purge -y "$pkg"
    fi
done < "$1"

echo "Nettoyage..."
sudo apt-get autoremove -y
sudo apt-get clean
