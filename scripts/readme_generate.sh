#!/bin/bash

SCRIPTS_DIR="$(dirname "$0")"
README="$(dirname "$0")/../README.md"

cat > "$README" <<EOF
# Scripts disponibles

| Script | Description | Usage | Exemple |
|--------|-------------|-------|---------|
EOF

for script in "$SCRIPTS_DIR"/*; do
    # Ignore ce script lui-même et les fichiers non exécutables
    [ "$script" = "$SCRIPTS_DIR/readme_generate.sh" ] && continue
    [ ! -x "$script" ] && continue
    name="$(basename "$script")"
    echo "Test aide : $name" 1>&2
    # Vérifie si le script gère l'option -h
    if grep -qE '\$\{?1\}? *([=]{1,2}) *-h|\[\[? *\$\{?1\}? *([=]{1,2}) *-h *\]?\]?|\-h *\)' "$script"; then
        # Récupère l'aide du script avec timeout pour éviter les blocages
        helpout=$(timeout 2s bash "$script" -h 2>/dev/null | head -n 10)
        desc=$(echo "$helpout" | grep -m1 -v Usage | grep -v Exemple | head -n1 | sed 's/^ *//')
        usage=$(echo "$helpout" | grep -m1 Usage | sed 's/^ *//')
        exemple=$(echo "$helpout" | grep -m1 Exemple | sed 's/^ *//')
        [ -z "$desc" ] && desc="-"
        [ -z "$usage" ] && usage="-"
        [ -z "$exemple" ] && exemple="-"
        echo "| $name | $desc | $usage | $exemple |" >> "$README"
    else
        echo "[WARN] $name ne gère pas l'option -h" 1>&2
        echo "| $name | - | - | - |" >> "$README"
    fi
done

echo "|--------|-------------|-------|---------|" >> "$README"

for script in "$SCRIPTS_DIR"/*; do
    # Ignore ce script lui-même et les fichiers non exécutables
    [ "$script" = "$SCRIPTS_DIR/readme_generate.sh" ] && continue
    [ ! -x "$script" ] && continue
    name="$(basename "$script")"
    echo "Test aide : $name" 1>&2
    # Vérifie si le script gère l'option -h
    if grep -qE '\$\{?1\}? *== *-h|-h *\)' "$script"; then
        # Récupère l'aide du script avec timeout pour éviter les blocages
        helpout=$(timeout 2s bash "$script" -h 2>/dev/null | head -n 10)
        desc=$(echo "$helpout" | grep -m1 -v Usage | grep -v Exemple | head -n1 | sed 's/^ *//')
        usage=$(echo "$helpout" | grep -m1 Usage | sed 's/^ *//')
        exemple=$(echo "$helpout" | grep -m1 Exemple | sed 's/^ *//')
        [ -z "$desc" ] && desc="-"
        [ -z "$usage" ] && usage="-"
        [ -z "$exemple" ] && exemple="-"
        echo "| $name | $desc | $usage | $exemple |" >> "$README"
    else
        echo "[WARN] $name ne gère pas l'option -h" 1>&2
        echo "| $name | - | - | - |" >> "$README"
    fi
done

echo -e "\nREADME généré automatiquement à partir des scripts du dossier scripts/." >> "$README"
