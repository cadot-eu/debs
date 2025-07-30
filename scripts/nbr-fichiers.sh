if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo -e "\nCompte le nombre de fichiers dans chaque sous-dossier."
  echo "Usage: nbr-fichiers.sh"
  echo "Exemple: nbr-fichiers.sh"
  exit 0
fi
for i in *; do echo -n $i " " ; find $i |wc -l; done | sort -n -k2

