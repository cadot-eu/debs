#!/bin/bash

# Supprimer le fichier d'événement ACPI et le script d'action
echo "Suppression des fichiers ACPI..."
sudo rm -f /etc/acpi/events/lid-event
sudo rm -f /etc/acpi/lid-action.sh

# Rétablir les paramètres par défaut pour logind.conf
echo "Réinitialisation des paramètres par défaut pour /etc/systemd/logind.conf..."
sudo sed -i '/^HandleLidSwitch=ignore/d' /etc/systemd/logind.conf
sudo sed -i '/^HandleLidSwitchExternalPower=ignore/d' /etc/systemd/logind.conf
sudo sed -i '/^HandleLidSwitchDocked=ignore/d' /etc/systemd/logind.conf

# Redémarrer les services pour appliquer les modifications
echo "Redémarrage des services pour prendre en compte les modifications..."
sudo systemctl restart acpid
sudo systemctl restart systemd-logind

echo "Réinitialisation et nettoyage terminés."
