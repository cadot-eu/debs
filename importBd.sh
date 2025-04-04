#!/bin/bash

# 📌 Vérification des arguments
if [[ $# -lt 5 ]]; then
    echo "❌ Usage: $0 NOM_CONTENEUR NOM_BDD NOM_UTILISATEUR MOT_DE_PASSE FICHIER_SQL"
    exit 1
fi

# 📌 Assignation des arguments
CONTAINER_NAME="$1"
DB_NAME="$2"
PG_USER="$3"
PG_PASSWORD="$4"
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
