#!/bin/bash

CONFIG_FILE="/etc/systemd/logind.conf"

install() {
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

    # Modifier les paramètres pour la batterie et le secteur
    sudo sed -i '/^HandleLidSwitch=/c\HandleLidSwitch=ignore' $CONFIG_FILE
    sudo sed -i '/^HandleLidSwitchExternalPower=/c\HandleLidSwitchExternalPower=ignore' $CONFIG_FILE
    sudo sed -i '/^HandleLidSwitchDocked=/c\HandleLidSwitchDocked=ignore' $CONFIG_FILE

    if ! grep -q "^HandleLidSwitch=" $CONFIG_FILE; then
        echo "HandleLidSwitch=ignore" | sudo tee -a $CONFIG_FILE
    fi
    if ! grep -q "^HandleLidSwitchExternalPower=" $CONFIG_FILE; then
        echo "HandleLidSwitchExternalPower=ignore" | sudo tee -a $CONFIG_FILE
    fi
    if ! grep -q "^HandleLidSwitchDocked=" $CONFIG_FILE; then
        echo "HandleLidSwitchDocked=ignore" | sudo tee -a $CONFIG_FILE
    fi

    # Redémarrer les services pour appliquer les modifications
    sudo systemctl restart acpid
    sudo systemctl restart systemd-logind

    # Autoriser l'utilisateur actuel à exécuter pm-suspend sans mot de passe
    echo "${USER} ALL=NOPASSWD: /usr/sbin/pm-suspend" | sudo tee /etc/sudoers.d/pm-suspend-${USER}
    sudo chmod 0440 /etc/sudoers.d/pm-suspend-${USER}
    
    echo "Installation et configuration terminées."
}

uninstall() {
    # Supprimer le fichier d'événement ACPI et le script d'action
    echo "Suppression des fichiers ACPI..."
    sudo rm -f /etc/acpi/events/lid-event
    sudo rm -f /etc/acpi/lid-action.sh

    # Rétablir les paramètres par défaut pour logind.conf
    echo "Réinitialisation des paramètres par défaut pour /etc/systemd/logind.conf..."
    sudo sed -i '/^HandleLidSwitch=ignore/d' $CONFIG_FILE
    sudo sed -i '/^HandleLidSwitchExternalPower=ignore/d' $CONFIG_FILE
    sudo sed -i '/^HandleLidSwitchDocked=ignore/d' $CONFIG_FILE

    # Redémarrer les services pour appliquer les modifications
    sudo systemctl restart acpid
    sudo systemctl restart systemd-logind

    # Supprimer la règle sudo pour pm-suspend de l'utilisateur actuel
    sudo rm -f /etc/sudoers.d/pm-suspend-${USER}

    echo "Réinitialisation et nettoyage terminés."
}

display_help() {
    echo "Utilisation : $0 [OPTION]"
    echo -e "\nOptions disponibles :"
    echo "--install      Installer et configurer la gestion de l'énergie et les événements ACPI."
    echo "--uninstall    Réinitialiser les configurations et supprimer les fichiers créés."
    echo "-h, --help     Afficher l'aide."
    echo " une fois cette installation faites il est possible de lancer 'sudo /usr/sbin/pm-suspend' sans taper de mot de passe, donc de créer un touche de raccouris pour lancer suspend"
}

# Contrôler les options du script
case "$1" in
    --install)
        install
        ;;
    --uninstall)
        uninstall
        ;;
    -h|--help)
        display_help
        ;;
    *)
        echo "Option non reconnue. Utilisez -h ou --help pour afficher l'aide."
        exit 1
        ;;
esac
