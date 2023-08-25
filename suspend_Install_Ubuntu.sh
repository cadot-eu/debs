#!/bin/bash
sudo apt install -y pm-utils

# Créer le fichier d'événement ACPI pour la fermeture du couvercle
echo "Création du fichier /etc/acpi/events/lid-event..."
sudo tee /etc/acpi/events/lid-event > /dev/null <<EOL
event=button/lid.*
action=/etc/acpi/lid-action.sh %e
EOL

# Créer le script d'action pour la fermeture du couvercle
echo "Création du fichier /etc/acpi/lid-action.sh..."
sudo tee /etc/acpi/lid-action.sh > /dev/null <<EOL
#!/bin/bash

# Ajoutez vos commandes ici
# Par exemple : pm-suspend
EOL

# Rendre le script d'action exécutable
sudo chmod +x /etc/acpi/lid-action.sh

# Modifier le fichier logind.conf
echo "Modification du fichier /etc/systemd/logind.conf..."
sudo sed -i '/^HandleLidSwitch=/c\HandleLidSwitch=ignore' /etc/systemd/logind.conf
sudo sed -i '/^HandleLidSwitchExternalPower=/c\HandleLidSwitchExternalPower=ignore' /etc/systemd/logind.conf
sudo sed -i '/^HandleLidSwitchDocked=/c\HandleLidSwitchDocked=ignore' /etc/systemd/logind.conf
if ! grep -q "HandleLidSwitch=ignore" /etc/systemd/logind.conf; then
    echo "HandleLidSwitch=ignore" | sudo tee -a /etc/systemd/logind.conf
fi
if ! grep -q "HandleLidSwitchExternalPower=ignore" /etc/systemd/logind.conf; then
    echo "HandleLidSwitchExternalPower=ignore" | sudo tee -a /etc/systemd/logind.conf
fi
if ! grep -q "HandleLidSwitchDocked=ignore" /etc/systemd/logind.conf; then
    echo "HandleLidSwitchDocked=ignore" | sudo tee -a /etc/systemd/logind.conf
fi

# Redémarrer les services pour appliquer les modifications
echo "Redémarrage des services pour prendre en compte les modifications..."
sudo systemctl restart acpid
sudo systemctl restart systemd-logind

echo "Installation et configuration terminées."
