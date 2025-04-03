#!/bin/bash

# 📌 Fonction pour afficher l'aide
function show_help {
    echo "Usage: $0 NOM_CONTENEUR NOM_BDD NOM_UTILISATEUR MOT_DE_PASSE FICHIER_SQL"
    echo ""
}

# 📌 Vérification du nombre d'arguments
if [[ $# -lt 5 ]]; then
    echo "❌ Trop peu de paramètres. Vous devez fournir :"
    echo " 1. Nom du conteneur PostgreSQL"
    echo " 2. Nom de la base de données"
    echo " 3. Nom d'utilisateur PostgreSQL"
    echo " 4. Mot de passe PostgreSQL"
    echo " 5. Fichier SQL à importer"
    show_help
    exit 1
fi

# 📌 Assignation des arguments
CONTAINER_NAME="$1"
DB_NAME="$2"
PG_USER="$3"
PG_PASSWORD="$4"
SELECTED_FILE="$5"

if [[ "$DB_EXISTS" == "1" ]]; then
    echo "⚠️ La base '$DB_NAME' existe déjà. Suppression en cours..."
    docker exec -t "$CONTAINER_NAME" psql -U "$PG_USER" -d postgres -c "DROP DATABASE \"$DB_NAME\";"
else
    echo "✅ La base '$DB_NAME' n'existe pas."
fi


# 📌 Suppression des tables existantes (en cas de nécessité)
echo "🧹 Suppression des anciennes tables..."
docker exec -t "$CONTAINER_NAME" psql -U "$PG_USER" -d "$DB_NAME" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"


echo "📥 Fichier sélectionné : $SELECTED_FILE"
echo "🔍 Vérification de l'existence de la base '$DB_NAME'..."

# 📌 Vérifier si la base de données existe, sinon la créer
export PGPASSWORD=$PG_PASSWORD
DB_EXISTS=$(docker exec -t "$CONTAINER_NAME" psql -U "$PG_USER" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" | tr -d '[:space:]')
if [[ "$DB_EXISTS" != "1" ]]; then
    echo "⚠️ La base '$DB_NAME' n'existe pas. Création en cours..."
    docker exec -t "$CONTAINER_NAME" psql -U "$PG_USER" -d postgres -c "CREATE DATABASE \"$DB_NAME\";"
    echo "✅ Base '$DB_NAME' créée avec succès."
else
    echo "✅ La base '$DB_NAME' existe déjà."
fi

# 📌 Importation de la base de données
echo "📥 Importation en cours..."
docker exec -i "$CONTAINER_NAME" psql -U "$PG_USER" -d "$DB_NAME" < "$SELECTED_FILE"
if [[ $? -eq 0 ]]; then
    echo "✅ Importation terminée avec succès."
else
    echo "❌ Erreur lors de l'importation."
    exit 1
fi

# 📌 Restaurer les fichiers uploadés si un fichier ZIP est trouvé
UPLOAD_ZIP="uploads_backup_${DB_NAME}_*.zip"
UPLOAD_ZIP_FILE=$(ls $UPLOAD_ZIP 2>/dev/null | head -n 1)
if [[ -n "$UPLOAD_ZIP_FILE" ]]; then
    echo "📦 Détection d'une sauvegarde des fichiers uploads : $UPLOAD_ZIP_FILE"
    read -p "⚠️ Veux-tu restaurer les fichiers uploads ? (oui/non) : " CONFIRM_UPLOADS
    
    if [[ "$CONFIRM_UPLOADS" == "oui" ]]; then
        unzip -o "$UPLOAD_ZIP_FILE" -d .
        echo "✅ Fichiers uploads restaurés."
    else
        echo "⚠️ Restauration des fichiers uploads annulée."
    fi
else
    echo "⚠️ Aucun fichier de sauvegarde d'uploads trouvé."
fi

echo "🎉 Restauration terminée avec succès !"
