if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo -e "\nMet à jour le fichier hosts blacklisté (Ultimate Hosts Blacklist)."
  echo "Usage: hosts-pub-update.sh"
  echo "Exemple: sudo ./hosts-pub-update.sh"
  exit 0
fi
#!/bin/bash

# Linux hosts Updater for the Ultimate Hosts Blacklist
# Repo Url: https://github.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist
# Copyright (c) 2020 Ultimate Hosts Blacklist - @Ultimate-Hosts-Blacklist
# Copyright (c) 2017, 2018, 2019, 2020 Mitchell Krog - @mitchellkrogza
# Copyright (c) 2017, 2018, 2019, 2020 Nissar Chababy - @funilrys

# Get the latest updated hosts file and put it into place
sudo wget https://hosts.ubuntu101.co.za/hosts -O /etc/hosts

exit 0
