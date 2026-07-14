#!/bin/bash

FICHIER_HOSTS="/etc/hosts"
MARQUEUR_DEBUT="# DEBUT APPARELS ESPHOME"
MARQUEUR_FIN="# FIN APPARELS ESPHOME"

if [ "$EUID" -ne 0 ]; then
    echo "sudo requis"
    exit 1
fi

# Sauvegarde
cp "$FICHIER_HOSTS" "$FICHIER_HOSTS.backup"

# Supprimer l'ancienne section
sed -i "/$MARQUEUR_DEBUT/,/$MARQUEUR_FIN/d" "$FICHIER_HOSTS"

echo "$MARQUEUR_DEBUT" >> "$FICHIER_HOSTS"
echo "# Mise à jour le $(date)" >> "$FICHIER_HOSTS"

# Récupérer les appareils avec le bon parsing
count=0
avahi-browse -r _esphomelib._tcp --resolve --terminate 2>/dev/null | \
grep -E "hostname|address" | \
awk '
    /hostname/ {
        # Enlever les crochets
        gsub(/[\[\]]/, "", $3)
        host=$3
    }
    /address/ {
        gsub(/[\[\]]/, "", $3)
        ip=$3
        if (host && ip) {
            print host, ip
            host=""
            ip=""
        }
    }
' | \
sed 's/\.local$//' | \
while read nom ip; do
    if [ -n "$nom" ] && [ -n "$ip" ]; then
        echo "$ip    $nom.local    $nom    # ESPHome" >> "$FICHIER_HOSTS"
        echo "✅ $nom -> $ip"
        ((count++))
    fi
done

echo "$MARQUEUR_FIN" >> "$FICHIER_HOSTS"
echo "✅ $count appareils ajoutés"
sudo resolvectl flush-caches
