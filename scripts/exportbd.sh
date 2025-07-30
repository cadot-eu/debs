if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "\nExport PostgreSQL + uploads."
    echo "Usage: exportbd.sh [CONTAINER DB USER PASS TIMESTAMP DEST_DIR SITE_DIR]"
    echo "Si aucun paramètre n'est fourni, le script est interactif."
    echo "Exemple: exportbd.sh rss-db dbrss rss '' 20250730_1200 /tmp/rss-backup rss"
    exit 0
fi
#!/bin/bash

# 📌 Demander les paramètres si ils ne sont pas fournis
if [[ $# -lt 7 ]]; then
    read -p "Nom du conteneur PostgreSQL (par défaut: rss-db): " CONTAINER_NAME
    CONTAINER_NAME=${CONTAINER_NAME:-"rss-db"}
    read -p "Nom de la base de données (par défaut: dbrss): " DB_NAME
    DB_NAME=${DB_NAME:-"dbrss"}
    read -p "Nom de l'utilisateur PostgreSQL (par défaut: rss): " PG_USER
    PG_USER=${PG_USER:-"rss"}
    read -p "Mot de passe PostgreSQL (par défaut: vide): " PG_PASSWORD
    PG_PASSWORD=${PG_PASSWORD:-""}
    read -p "Date et heure de sauvegarde (par défaut: maintenant): " TIMESTAMP
    if [[ -z "$TIMESTAMP" ]]; then
        TIMESTAMP=$(date +"%Y%m%d%H%M%S")
    fi
    read -p "Dossier de destination (par défaut: dir en cours): " DEST_DIR
    DEST_DIR=${DEST_DIR:-.}
    read -p "Dossier du site pour sauvegardé fichier rss/public/uploads(par défaut: rss): " SITE_DIR
    SITE_DIR=${SITE_DIR:-"rss"}
fi

# 📌 Récupérer les paramètres ou demander à l'utilisateur
CONTAINER_NAME=${1:-$CONTAINER_NAME}
DB_NAME=${2:-$DB_NAME}
PG_USER=${3:-$PG_USER}
PG_PASSWORD=${4:-$PG_PASSWORD}
TIMESTAMP=${5:-$TIMESTAMP}
DEST_DIR=${6:-$DEST_DIR}
SITE_DIR=${7:-$SITE_DIR}


# 📌 Définir les noms des fichiers de sauvegarde
DB_BACKUP_FILE="${DEST_DIR}/${DB_NAME}_${TIMESTAMP}.sql"
UPLOADS_BACKUP_FILE="${DEST_DIR}/${DB_NAME}_${TIMESTAMP}.tar.gz"

echo "📤 Sauvegarde de la base '$DB_NAME' depuis le conteneur '$CONTAINER_NAME'..."

# 📌 Export de la base de données avec authentification
export PGPASSWORD=$PG_PASSWORD
docker exec -t "$CONTAINER_NAME" pg_dump -U "$PG_USER" -d "$DB_NAME" > "$DB_BACKUP_FILE" 2> "${DEST_DIR}/error_${DB_NAME}_${TIMESTAMP}.log"
echo 'docker exec -t "${CONTAINER_NAME}" pg_dump -U "${PG_USER}" -d "${DB_NAME}" > "${DB_BACKUP_FILE}" '

if [[ $? -eq 0 ]]; then
    echo "✅ Base de données sauvegardée dans '$DB_BACKUP_FILE'."
else
    echo "❌ Erreur lors de l'export de la base de données. Vérifie '${DEST_DIR}/error_${DB_NAME}_${TIMESTAMP}.log' pour plus de détails."
    exit 1
fi

# 📌 Sauvegarde du dossier public/uploads
UPLOADS_DIR="${SITE_DIR}/public/uploads"

if [[ -d "$UPLOADS_DIR" ]]; then
    echo "📦 Sauvegarde des fichiers '$UPLOADS_DIR'..."
    tar -czf "$UPLOADS_BACKUP_FILE" -C "$SITE_DIR" "public/uploads" 2> "${DEST_DIR}/errorFichiers_${DB_NAME}_${TIMESTAMP}.log"
    
    if [[ $? -eq 0 ]]; then
        echo "✅ Uploads sauvegardés dans '$UPLOADS_BACKUP_FILE'."
    else
        echo "❌ Erreur lors de la sauvegarde des fichiers uploads."
        exit 1
    fi
else
    echo "⚠️ Le dossier '$UPLOADS_DIR' n'existe pas. Aucun fichier sauvegardé."
fi

echo "🎉 Sauvegarde terminée avec succès !"
