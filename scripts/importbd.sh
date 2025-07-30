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

  echo "Exemple: ./importbd.sh"
  exit 0
fi
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
# Recherche SSH dans .env.local ou .env
SSH_HOST=""
if [ -f ".env.local" ]; then
    SSH_HOST=$(grep '^SSH=' .env.local | cut -d '=' -f2)
    if [ -n "$SSH_HOST" ]; then
        echo "🔑 SSH détecté dans .env.local : $SSH_HOST"
    fi
    elif [ -f ".env" ]; then
    SSH_HOST=$(grep '^SSH=' .env | cut -d '=' -f2)
    if [ -n "$SSH_HOST" ]; then
        echo "🔑 SSH détecté dans .env : $SSH_HOST"
    fi
fi

if [ -n "$SSH_HOST" ]; then
    # Récupère la liste des fichiers sql du répertoire backups et l'affiche
    distant_files=$(ssh $SSH_HOST "ls -1 backups/${DEFAULT_NAME}_*.sql" 2>/dev/null | nl)
    if [ -n "$distant_files" ]; then
        echo "\n📁 Fichiers SQL distants trouvés :"
        echo "$distant_files"
        read -p "Numéro du fichier SQL distant à importer: " file_number
        SELECTED_FILE=$(ssh $SSH_HOST "ls -1 backups/${DEFAULT_NAME}_*.sql" 2>/dev/null | awk -v num="$file_number" 'NR == num {print $1}' | xargs -n1 basename)
        if [ -n "$SELECTED_FILE" ]; then
            # Récupère le fichier SQL distant
            scp $SSH_HOST:backups/$SELECTED_FILE .
            # Récupère le fichier tar.gz associé si demandé
            read -p "Voulez-vous récupérer le fichier tar.gz associé ? (O/n): " response
            response=${response,,}
            if [[ -z "$response" || "$response" == "o" || "$response" == "y" ]]; then
                SELECTED_FILE_BASENAME=$(basename "$SELECTED_FILE")
                SELECTED_FILE_TAR_GZ=${SELECTED_FILE_BASENAME%.sql}.tar.gz
                scp $SSH_HOST:backups/$SELECTED_FILE_TAR_GZ .
            fi
        else
            echo "❌ Sélection invalide. Veuillez choisir un numéro de fichier correct."
            exit 1
        fi
    else
        echo "❗ Aucun fichier SQL distant trouvé sur $SSH_HOST dans backups/. Format attendu : ${DEFAULT_NAME}_*.sql"
        # Sinon propose les fichiers .sql locaux
        select_file=$(ls *.sql 2>/dev/null | nl)
        if [ -z "$select_file" ]; then
            echo "❌ Aucun fichier .sql trouvé dans le répertoire courant. Format attendu : *.sql"
            exit 1
        fi
        echo ""
        echo "📁 Fichiers SQL locaux :"
        echo "$select_file"
        read -p "Numéro du fichier SQL local à importer: " file_number
        SELECTED_FILE=$(echo "$select_file" | awk -v num="$file_number" '$1 == num {print $2}')
    fi
else
    echo "ℹ️ Aucun SSH détecté dans .env.local ou .env."
    select_file=$(ls *.sql 2>/dev/null | nl)
    if [ -z "$select_file" ]; then
        echo "❌ Aucun fichier .sql trouvé dans le répertoire courant. Format attendu : *.sql"
        exit 1
    fi
    echo ""
    echo "📁 Fichiers SQL locaux :"
    echo "$select_file"
    read -p "Numéro du fichier SQL local à importer: " file_number
    SELECTED_FILE=$(echo "$select_file" | awk -v num="$file_number" '$1 == num {print $2}')
fi


# Si SELECTED_FILE est déjà défini (fichier distant sélectionné), ne pas redemander la sélection locale
if [ -z "$SELECTED_FILE" ]; then
    echo "📁 Fichiers SQL disponibles :"
    echo "$select_file"
    read -p "Numéro du fichier SQL ou dump à importer: " file_number
    SELECTED_FILE=$(echo "$select_file" | awk -v num="$file_number" '$1 == num {print $2}')
    if [ -z "$SELECTED_FILE" ]; then
        echo "❌ Sélection invalide. Veuillez choisir un numéro de fichier correct."
        exit 1
    fi
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

echo "🚀 Configuration : 📦 Conteneur: $CONTAINER_NAME 🗄️ Base: $DB_NAME 👤 Utilisateur: $PG_USER 📁 Fichier: $SELECTED_FILE 💾 Volume: $VOLUME_NAME"

# 📌 SUPPRESSION COMPLÈTE SI DEMANDÉE
if [[ "$PURGE_VOLUME" == "y" || "$PURGE_VOLUME" == "Y" ]]; then
    echo ""
    echo "🗑️ === SUPPRESSION COMPLÈTE EN COURS ==="
    
    # Arrêter le conteneur
    docker stop "$CONTAINER_NAME" 2>/dev/null || echo "ℹ️ Conteneur déjà arrêté"
    
    # Supprimer le conteneur
    docker rm -f "$CONTAINER_NAME" 2>/dev/null || echo "ℹ️ Conteneur déjà supprimé"
    
    # Supprimer le volume (silencieux)
    docker volume rm "$VOLUME_NAME" 2>/dev/null || docker volume rm "$VOLUME_NAME" --force 2>/dev/null || echo "ℹ️ Volume déjà supprimé ou inexistant"
    
    # Redémarrer avec docker-compose
    echo "🔄 Redémarrage des services..."
    if [[ -f "docker-compose.yml" ]]; then
        docker-compose up -d "$CONTAINER_NAME"
        echo "⏳ Attente du démarrage du conteneur..."
        sleep 15
        elif [[ -f "compose.yml" ]]; then
        docker compose up -d "$CONTAINER_NAME"
        echo "⏳ Attente du démarrage du conteneur..."
        sleep 15
    else
        echo "⚠️ Aucun fichier docker-compose trouvé."
        
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
    " >/dev/null 2>&1
    docker exec -t "$CONTAINER_NAME" psql -U "$PG_USER" -d postgres -c "DROP DATABASE \"$DB_NAME\";" >/dev/null 2>&1
fi

# 📌 Création de la base
echo "🏗️ Création de la base '$DB_NAME'..."
docker exec -t "$CONTAINER_NAME" psql -U "$PG_USER" -d postgres -c "CREATE DATABASE \"$DB_NAME\";" >/dev/null 2>&1
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
if [[ "$FILE_TYPE" == "application/x-sql" ]] || [[ "$SELECTED_FILE" == *.sql ]]; then
    # Filtrer les lignes contenant ALTER OWNER pour éviter l'erreur
    sed '/OWNER TO/d' "$SELECTED_FILE" | docker exec -i "$CONTAINER_NAME" psql -U "$PG_USER" -d "$DB_NAME" >/dev/null
    elif [[ "$FILE_TYPE" == "application/octet-stream" ]] || [[ "$SELECTED_FILE" == *.dump ]]; then
    docker exec -i "$CONTAINER_NAME" pg_restore --no-owner -U "$PG_USER" -d "$DB_NAME" < "$SELECTED_FILE" >/dev/null
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

if [[ "$PURGE_VOLUME" == "y" || "$PURGE_VOLUME" == "Y" ]]; then
    echo "   🗑️ Volume complètement supprimé et recréé"
fi
echo ""
SELECTED_FILE_TAR_GZ=$(echo "$SELECTED_FILE" | sed 's/\.sql$/\.tar\.gz/')
if [[ -f "$SELECTED_FILE_TAR_GZ" ]]; then
    sudo rm public/uploads -R
    sudo tar xvzf "$SELECTED_FILE_TAR_GZ"
    echo "vos fichiers de sauvegarde sont maintenant dans le dossier public/uploads"
else
    echo "Aucun fichier \"$SELECTED_FILE_TAR_GZ\" de sauvegarde trouvé."
fi
echo "🎉 Restauration terminée avec succès !"