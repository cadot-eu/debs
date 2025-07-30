#!/bin/bash
# Génère dynamiquement le README.md à partir des scripts présents dans scripts/

SCRIPTS_DIR="$(dirname "$0")"
README="$(dirname "$0")/../README.md"

cat > "$README" <<EOF
# Scripts disponibles

| Script | Description | Usage | Exemple |
|--------|-------------|-------|---------|
EOF

for script in "$SCRIPTS_DIR"/*.sh; do
    name="$(basename "$script")"
    # Récupère l'aide du script
    helpout=$(bash "$script" -h 2>/dev/null | head -n 10)
    desc=$(echo "$helpout" | grep -m1 -v Usage | grep -v Exemple | head -n1 | sed 's/^ *//')
    usage=$(echo "$helpout" | grep -m1 Usage | sed 's/^ *//')
    exemple=$(echo "$helpout" | grep -m1 Exemple | sed 's/^ *//')
    [ -z "$desc" ] && desc="-"
    [ -z "$usage" ] && usage="-"
    [ -z "$exemple" ] && exemple="-"
    echo "| $name | $desc | $usage | $exemple |" >> "$README"
done

echo -e "\nREADME généré automatiquement à partir des scripts du dossier scripts/." >> "$README"
SCRIPTS_DIR="$(dirname "$0")"
README="$(dirname "$0")/../README.md"

cat > "$README" <<EOF
# Scripts disponibles

| Script | Description | Usage | Exemple |
|--------|-------------|-------|---------|
EOF

for script in "$SCRIPTS_DIR"/*.sh; do
  name="$(basename "$script")"
  # Récupère l'aide du script
  helpout=$(bash "$script" -h 2>/dev/null | head -n 10)
  desc=$(echo "$helpout" | grep -m1 -v Usage | grep -v Exemple | head -n1 | sed 's/^ *//')
  usage=$(echo "$helpout" | grep -m1 Usage | sed 's/^ *//')
  exemple=$(echo "$helpout" | grep -m1 Exemple | sed 's/^ *//')
  [ -z "$desc" ] && desc="-"
  [ -z "$usage" ] && usage="-"
  [ -z "$exemple" ] && exemple="-"
  echo "| $name | $desc | $usage | $exemple |" >> "$README"
done

echo -e "\nREADME généré automatiquement à partir des scripts du dossier scripts/." >> "$README"
