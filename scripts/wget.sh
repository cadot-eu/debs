if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo -e "\nTélécharge un fichier avec reprise et limitation de débit."
  echo "Usage: wget.sh URL [limite]"
  echo "Exemple: wget.sh https://site/fichier.zip 500k"
  exit 0
fi
curl $1 -C - -k -O  --limit-rate ${2:-300k}
