#!/bin/bash

# 🗑️ Script complet : Suppression complète + Import PostgreSQL
# Usage: ./postgres_reset_import.sh [conteneur] [db] [user] [password] [fichier]

# 📌 Récupère le nom du dossier courant
DEFAULT_NAME=$(basename "$PWD")

# 📌 Valeurs par défaut basées sur le nom du dossier
DEFAULT_CONTAINER="${DEFAULT_NAME}-db"
DEFAULT_DB="db${DEFAULT_NAME}"
DEFAULT_USER="${DEFAULT_NAME}"
DEFAULT_VOLUME="database_data-${DEFAULT_NAME}"

# 📌 Demande d'infos avec valeurs par défaut intelligentes
read -p "Nom du conteneur PostgreSQL (par défaut: ${DEFAULT_CONTAINER}): " CONTAINER_NAME
CONTAINER_NAME=${CONTAINER_NAME:-$DEFAULT_CONTAINER}

read -p "Nom de la base de données (par défaut: ${DEFAULT_DB}): " DB_NAME
DB_NAME=${DB_NAME:-$DEFAULT_DB}

read -p "Nom de l'utilisateur PostgreSQL (par défaut: ${DEFAULT_USER}): " PG_USER
PG_USER=${PG_USER:-$DEFAULT_USER}

read -p "Mot de passe PostgreSQL (par défaut: vide): " PG_PASSWORD

VOLUME_NAME=$DEFAULT_VOLUME

# 📌 Sélection du fichier SQL
select_file=$(ls *.sql 2>/dev/null | nl)
if [ -z "$select_file" ]; then
    echo "❌ Aucun fichier .sql trouvé dans le répertoire courant."
    exit 1
fi

echo "📁 Fichiers SQL disponibles :"
echo "$select_file"
read -p "Numéro du fichier SQL ou dump à importer: " file_number

SELECTED_FILE=$(echo "$select_file" | awk -v num="$file_number" '$1 == num {print $2}')
if [ -z "$SELECTED_FILE" ]; then
    echo "❌ Sélection invalide. Veuillez choisir un numéro de fichier correct."
    exit 1
fi

# 📌 Assignation des arguments en ligne de commande (prioritaire)
CONTAINER_NAME=${1:-$CONTAINER_NAME}
DB_NAME=${2:-$DB_NAME}
PG_USER=${3:-$PG_USER}
PG_PASSWORD=${4:-$PG_PASSWORD}
SELECTED_FILE=${5:-$SELECTED_FILE}

# 📌 Vérifier si le fichier d'import existe
if [[ ! -f "$SELECTED_FILE" ]]; then
    echo "❌ Le fichier d'importation '$SELECTED_FILE' n'existe pas."
    exit 1
fi

echo "🚀 Configuration :"
echo "   📦 Conteneur: $CONTAINER_NAME"
echo "   🗄️ Base: $DB_NAME"
echo "   👤 Utilisateur: $PG_USER"
echo "   📁 Fichier: $SELECTED_FILE"
echo "   💾 Volume: $VOLUME_NAME"

# 📌 SUPPRESSION COMPLÈTE SI DEMANDÉE
if [[ "$PURGE_VOLUME" == "y" || "$PURGE_VOLUME" == "Y" ]]; then
    echo ""
    echo "🗑️ === SUPPRESSION COMPLÈTE EN COURS ==="
    
    # Arrêter le conteneur
    echo "⏹️ Arrêt du conteneur $CONTAINER_NAME..."
    docker stop "$CONTAINER_NAME" 2>/dev/null || echo "ℹ️ Conteneur déjà arrêté"
    
    # Supprimer le conteneur
    echo "🗑️ Suppression du conteneur $CONTAINER_NAME..."
    docker rm -f "$CONTAINER_NAME" 2>/dev/null || echo "ℹ️ Conteneur déjà supprimé"
    
    # Supprimer le volume (silencieux)
    echo "🗑️ Suppression du volume $VOLUME_NAME..."
    docker volume rm "$VOLUME_NAME" 2>/dev/null || docker volume rm "$VOLUME_NAME" --force 2>/dev/null || echo "ℹ️ Volume déjà supprimé ou inexistant"
    
    # Redémarrer avec docker-compose
    echo "🔄 Redémarrage des services..."
    if [[ -f "docker-compose.yml" ]]; then
        echo "📋 Utilisation de docker-compose..."
        docker-compose up -d "$CONTAINER_NAME"
        echo "⏳ Attente du démarrage du conteneur..."
        sleep 15
        elif [[ -f "compose.yml" ]]; then
        echo "📋 Utilisation de compose.yml..."
        docker compose up -d "$CONTAINER_NAME"
        echo "⏳ Attente du démarrage du conteneur..."
        sleep 15
    else
        echo "⚠️ Aucun fichier docker-compose trouvé."
        echo "💡 Redémarrage manuel du conteneur..."
        
        # Créer un nouveau conteneur PostgreSQL
        docker run -d --name "$CONTAINER_NAME" \
        --network host \
        -e POSTGRES_DB="$DB_NAME" \
        -e POSTGRES_USER="$PG_USER" \
        -e POSTGRES_PASSWORD="$PG_PASSWORD" \
        -v "$VOLUME_NAME":/var/lib/postgresql/data \
        postgres:16-alpine
        
        echo "⏳ Attente du démarrage du conteneur..."
        sleep 15
    fi
    
    echo "✅ Suppression complète terminée !"
fi

# 📌 Attendre que le conteneur soit prêt
echo ""
echo "⏳ Vérification de l'état du conteneur..."
for i in {1..30}; do
    if docker exec "$CONTAINER_NAME" pg_isready -U "$PG_USER" >/dev/null 2>&1; then
        echo "✅ Conteneur PostgreSQL prêt !"
        break
    fi
    echo "⏳ Attente... ($i/30)"
    sleep 2
done

# 📌 Vérifier le type du fichier
FILE_TYPE=$(file -b --mime-type "$SELECTED_FILE")

# 📌 Configuration du mot de passe
export PGPASSWORD=$PG_PASSWORD

# 📌 Vérifier et supprimer la base si elle existe
echo "🔍 Vérification de l'existence de la base '$DB_NAME'..."
DB_EXISTS=$(docker exec -t "$CONTAINER_NAME" psql -U "$PG_USER" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" 2>/dev/null | tr -d '[:space:]')

if [[ "$DB_EXISTS" == "1" ]]; then
    echo "⚠️ La base '$DB_NAME' existe déjà. Suppression en cours..."
    docker exec -t "$CONTAINER_NAME" psql -U "$PG_USER" -d postgres -c "
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$DB_NAME' AND pid <> pg_backend_pid();
    "
    docker exec -t "$CONTAINER_NAME" psql -U "$PG_USER" -d postgres -c "DROP DATABASE \"$DB_NAME\";" 2>/dev/null
fi

# 📌 Création de la base
echo "🏗️ Création de la base '$DB_NAME'..."
docker exec -t "$CONTAINER_NAME" psql -U "$PG_USER" -d postgres -c "CREATE DATABASE \"$DB_NAME\";" 2>/dev/null
if [[ $? -eq 0 ]]; then
    echo "✅ Base '$DB_NAME' créée avec succès."
else
    echo "❌ Erreur lors de la création de la base."
    # Tenter de se connecter directement à la base si elle existe déjà
    if docker exec -t "$CONTAINER_NAME" psql -U "$PG_USER" -d "$DB_NAME" -c "SELECT 1;" >/dev/null 2>&1; then
        echo "ℹ️ La base existe déjà et est accessible. Continuons..."
    else
        exit 1
    fi
fi

# 📌 IMPORTATION
echo ""
echo "📥 === IMPORTATION EN COURS ==="
echo "📁 Fichier: $SELECTED_FILE"
echo "🔍 Type détecté: $FILE_TYPE"

if [[ "$FILE_TYPE" == "application/x-sql" ]] || [[ "$SELECTED_FILE" == *.sql ]]; then
    echo "📄 Import de fichier SQL..."
    # Filtrer les lignes contenant ALTER OWNER pour éviter l'erreur
    sed '/OWNER TO/d' "$SELECTED_FILE" | docker exec -i "$CONTAINER_NAME" psql -U "$PG_USER" -d "$DB_NAME"
    elif [[ "$FILE_TYPE" == "application/octet-stream" ]] || [[ "$SELECTED_FILE" == *.dump ]]; then
    echo "📦 Import de fichier dump..."
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

# 📌 Informations finales
echo ""
echo "🎉 === TERMINÉ AVEC SUCCÈS ==="
echo "   📦 Conteneur: $CONTAINER_NAME"
echo "   🗄️ Base: $DB_NAME"
echo "   👤 Utilisateur: $PG_USER"
echo "   📁 Import: $SELECTED_FILE"
if [[ "$PURGE_VOLUME" == "y" || "$PURGE_VOLUME" == "Y" ]]; then
    echo "   🗑️ Volume complètement supprimé et recréé"
fi
echo ""
echo "💡 Votre base de données est maintenant prête à l'utilisation !"