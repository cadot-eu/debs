#!/bin/bash

# 📌 Vérification des arguments
read -p "Nom du conteneur PostgreSQL (par défaut: rss-db): " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-"rss-db"}

read -p "Nom de la base de données (par défaut: dbrss): " DB_NAME
DB_NAME=${DB_NAME:-"dbrss"}

read -p "Nom de l'utilisateur PostgreSQL (par défaut: rss): " PG_USER
PG_USER=${PG_USER:-"rss"}

read -p "Mot de passe PostgreSQL (par défaut: vide): " PG_PASSWORD

select_file=$(ls *.sql | nl)
if [ -z "$select_file" ]; then
    echo "❌ Aucun fichier .sql trouvé dans le répertoire courant."
    exit 1
fi

echo "$select_file"
read -p "Numéro du fichier SQL ou dump à importer: " file_number

SELECTED_FILE=$(echo "$select_file" | awk -v num="$file_number" '$1 == num {print $2}')

if [ -z "$SELECTED_FILE" ]; then
    echo "❌ Sélection invalide. Veuillez choisir un numéro de fichier correct."
    exit 1
fi

# 📌 Assignation des arguments
CONTAINER_NAME=${1:-"rss-db"}
DB_NAME=${2:-"dbrss"}
PG_USER=${3:-"rss"}
PG_PASSWORD=""
SELECTED_FILE="$5"

# 📌 Vérifier si le fichier d'import existe
if [[ ! -f "$SELECTED_FILE" ]]; then
    echo "❌ Le fichier d'importation '$SELECTED_FILE' n'existe pas."
    exit 1
fi

# 📌 Vérifier le type du fichier (SQL ou Dump)
FILE_TYPE=$(file -b --mime-type "$SELECTED_FILE")

# 📌 Vérifier si la base existe
export PGPASSWORD=$PG_PASSWORD
DB_EXISTS=$(docker exec -t "$CONTAINER_NAME" psql -U "$PG_USER" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" | tr -d '[:space:]')

if [[ "$DB_EXISTS" == "1" ]]; then
    echo "⚠️ La base '$DB_NAME' existe déjà. Suppression en cours..."
    docker exec -t "$CONTAINER_NAME" psql -U "$PG_USER" -d postgres -c "DROP DATABASE \"$DB_NAME\";"
fi

# 📌 Création de la base
docker exec -t "$CONTAINER_NAME" psql -U "$PG_USER" -d postgres -c "CREATE DATABASE \"$DB_NAME\";"
echo "✅ Base '$DB_NAME' créée avec succès."

# 📌 Importation
echo "📥 Importation en cours..."

if [[ "$FILE_TYPE" == "application/x-sql" ]] || [[ "$SELECTED_FILE" == *.sql ]]; then
    # Filtrer les lignes contenant ALTER OWNER pour éviter l'erreur
    sed '/OWNER TO/d' "$SELECTED_FILE" | docker exec -i "$CONTAINER_NAME" psql -U "$PG_USER" -d "$DB_NAME"
    elif [[ "$FILE_TYPE" == "application/octet-stream" ]] || [[ "$SELECTED_FILE" == *.dump ]]; then
    docker exec -i "$CONTAINER_NAME" pg_restore --no-owner -U "$PG_USER" -d "$DB_NAME" < "$SELECTED_FILE"
else
    echo "❌ Format de fichier non reconnu. Veuillez fournir un fichier .sql ou .dump."
    exit 1
fi

# 📌 Vérification du succès de l'importation
if [[ $? -eq 0 ]]; then
    echo "✅ Importation terminée avec succès."
else
    echo "❌ Erreur lors de l'importation."
    exit 1
fi

echo "🎉 Restauration terminée avec succès !"
