#!/bin/bash

# 📌 Vérification du nombre d'arguments
if [[ $# -lt 6 ]]; then
    echo "❌ Trop peu de paramètres. Vous devez fournir :"
    echo " 1. Nom du conteneur PostgreSQL"
    echo " 2. Nom de la base de données"
    echo " 3. Nom d'utilisateur PostgreSQL"
    echo " 4. Mot de passe PostgreSQL"
    echo " 5. Horodatage (facultatif)"
    echo " 6. Répertoire de destination"
    exit 1
fi

# 📌 Récupérer les paramètres ou demander à l'utilisateur
CONTAINER_NAME=${1:-}
DB_NAME=${2:-}
PG_USER=${3:-}
PG_PASSWORD=${4:-}
TIMESTAMP=${5:-}
DEST_DIR=${6:-}

# 📌 Demande interactive si les paramètres ne sont pas fournis
if [[ -z "$CONTAINER_NAME" ]]; then
    read -p "Nom du conteneur PostgreSQL (par défaut : database) : " CONTAINER_NAME
    CONTAINER_NAME=${CONTAINER_NAME:-database}
fi

if [[ -z "$DB_NAME" ]]; then
    read -p "Nom de la base de données : " DB_NAME
fi

if [[ -z "$PG_USER" ]]; then
    read -p "Nom d'utilisateur PostgreSQL : " PG_USER
fi

if [[ -z "$PG_PASSWORD" ]]; then
    read -sp "Mot de passe PostgreSQL : " PG_PASSWORD
    echo ""
fi

if [[ -z "$TIMESTAMP" ]]; then
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
fi

if [[ -z "$DEST_DIR" ]]; then
    read -p "Répertoire de destination : " DEST_DIR
fi

# 📌 Vérification et création du répertoire de destination si nécessaire
mkdir -p "$DEST_DIR"

# 📌 Définir les noms des fichiers de sauvegarde
DB_BACKUP_FILE="${DEST_DIR}/backup_${DB_NAME}_${TIMESTAMP}.sql"
UPLOADS_BACKUP_FILE="${DEST_DIR}/uploads_backup_${DB_NAME}_${TIMESTAMP}.zip"

echo "📤 Sauvegarde de la base '$DB_NAME' depuis le conteneur '$CONTAINER_NAME'..."

# 📌 Export de la base de données avec authentification
export PGPASSWORD=$PG_PASSWORD
docker exec -t "$CONTAINER_NAME" pg_dump -U "$PG_USER" -d "$DB_NAME" > "$DB_BACKUP_FILE" 2> "${DEST_DIR}/error_${DB_NAME}_${TIMESTAMP}.log"

if [[ $? -eq 0 ]]; then
    echo "✅ Base de données sauvegardée dans '$DB_BACKUP_FILE'."
else
    echo "❌ Erreur lors de l'export de la base de données. Vérifie '${DEST_DIR}/error_${DB_NAME}_${TIMESTAMP}.log' pour plus de détails."
    exit 1
fi

# 📌 Sauvegarde du dossier public/uploads
if [[ -d "public/uploads" ]]; then
    echo "📦 Sauvegarde des fichiers 'public/uploads'..."
    zip -r "$UPLOADS_BACKUP_FILE" public/uploads 2> "${DEST_DIR}/errorFichiers_${DB_NAME}_${TIMESTAMP}.log"
    
    if [[ $? -eq 0 ]]; then
        echo "✅ Uploads sauvegardés dans '$UPLOADS_BACKUP_FILE'."
    else
        echo "❌ Erreur lors de la sauvegarde des fichiers uploads."
        exit 1
    fi
else
    echo "⚠️ Le dossier 'public/uploads' n'existe pas. Aucun fichier sauvegardé."
fi

echo "🎉 Sauvegarde terminée avec succès !"
