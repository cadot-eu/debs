#!/bin/bash

# 📌 Vérification du nombre d'arguments
if [[ $# -lt 7 ]]; then
    echo "❌ Trop peu de paramètres. Vous devez fournir :"
    echo " 1. Nom du conteneur PostgreSQL"
    echo " 2. Nom de la base de données"
    echo " 3. Nom d'utilisateur PostgreSQL"
    echo " 4. Mot de passe PostgreSQL (avec \\ sur caractère spéciaux)"
    echo " 5. jour ou date"
    echo " 6. Répertoire de destination"
    echo " 7. Répertoire du site"
    exit 1
fi

# 📌 Récupérer les paramètres ou demander à l'utilisateur
CONTAINER_NAME=${1:-}
DB_NAME=${2:-}
PG_USER=${3:-}
PG_PASSWORD=${4:-}
TIMESTAMP=${5:-}
DEST_DIR=${6:-}
SITE_DIR=${7:-}


# 📌 Définir les noms des fichiers de sauvegarde
DB_BACKUP_FILE="${DEST_DIR}/backup_${DB_NAME}_${TIMESTAMP}.sql"
UPLOADS_BACKUP_FILE="${DEST_DIR}/uploads_backup_${DB_NAME}_${TIMESTAMP}.tar.gz"

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
