#!/bin/bash

# Script pour configurer DNS Cloudflare et bloquer Proximus
# Pour Xubuntu avec NetworkManager

echo "================================================"
echo "Configuration DNS Cloudflare - Blocage Proximus"
echo "================================================"
echo ""

# Vérifier si le script est exécuté en root
# Connexions à configurer
CONNECTIONS=("eldino" "eldino5G")

# DNS Cloudflare
DNS_IPV4="1.1.1.1 1.0.0.1"
DNS_IPV6="2606:4700:4700::1111 2606:4700:4700::1001"

echo "🔧 Configuration des connexions..."
echo ""

for CONN in "${CONNECTIONS[@]}"; do
    # Vérifier si la connexion existe
    if nmcli connection show "$CONN" &> /dev/null; then
        echo "📡 Configuration de: $CONN"
        
        # IPv4
        nmcli connection modify "$CONN" ipv4.dns "$DNS_IPV4"
        nmcli connection modify "$CONN" ipv4.ignore-auto-dns yes
        echo "   ✓ IPv4 configuré (1.1.1.1)"
        
        # IPv6
        nmcli connection modify "$CONN" ipv6.dns "$DNS_IPV6"
        nmcli connection modify "$CONN" ipv6.ignore-auto-dns yes
        echo "   ✓ IPv6 configuré"
        
        echo ""
    else
        echo "⚠️  Connexion '$CONN' introuvable, ignorée"
        echo ""
    fi
done

# Backup du resolv.conf actuel
if [ -f /etc/resolv.conf ]; then
    sudo cp /etc/resolv.conf /etc/resolv.conf.backup.$(date +%Y%m%d-%H%M%S)
    echo "💾 Backup de /etc/resolv.conf créé"
fi

# Configurer NetworkManager pour ne pas toucher resolv.conf
echo ""
echo "🔧 Configuration de NetworkManager..."

NMCONF="/etc/NetworkManager/NetworkManager.conf"
if ! grep -q "dns=none" "$NMCONF" 2>/dev/null; then
    # Backup du fichier de config
    sudo cp "$NMCONF" "${NMCONF}.backup.$(date +%Y%m%d-%H%M%S)" 2>/dev/null
    
    # Ajouter dns=none dans la section [main]
    if grep -q "^\[main\]" "$NMCONF"; then
        sudo sed -i '/^\[main\]/a dns=none' "$NMCONF"
    else
        sudo echo "[main]" >> "$NMCONF"
        sudo echo "dns=none" >> "$NMCONF"
    fi
    echo "✓ NetworkManager configuré pour ne pas modifier resolv.conf"
else
    echo "✓ NetworkManager déjà configuré correctement"
fi

# Créer un resolv.conf protégé
echo ""
echo "🔒 Protection du fichier resolv.conf..."

sudo cat > /etc/resolv.conf << EOF
# Configuration DNS Cloudflare
# Généré automatiquement - $(date)
nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 2606:4700:4700::1111
nameserver 2606:4700:4700::1001
EOF

# Rendre le fichier immuable (optionnel)
sudo chattr -i /etc/resolv.conf 2>/dev/null
sudo chattr +i /etc/resolv.conf
echo "✓ /etc/resolv.conf protégé contre les modifications"

# Redémarrer NetworkManager
echo ""
echo "🔄 Redémarrage de NetworkManager..."
sudo systemctl restart NetworkManager
sleep 2

# Réactiver les connexions
echo ""
echo "🔄 Réactivation des connexions..."
for CONN in "${CONNECTIONS[@]}"; do
    if nmcli connection show "$CONN" &> /dev/null; then
        nmcli connection down "$CONN" 2>/dev/null
        sleep 1
        nmcli connection up "$CONN" 2>/dev/null
        echo "   ✓ $CONN reconnecté"
    fi
done

echo ""
echo "================================================"
echo "✅ Configuration terminée !"
echo "================================================"
echo ""
echo "📊 Vérification de la configuration:"
echo ""

# Afficher les DNS configurés
echo "DNS configurés dans NetworkManager:"
for CONN in "${CONNECTIONS[@]}"; do
    if nmcli connection show "$CONN" &> /dev/null; then
        echo "  → $CONN:"
        nmcli connection show "$CONN" | grep -E "ipv[46].(dns|ignore-auto-dns)" | sed 's/^/    /'
    fi
done

echo ""
echo "Contenu de /etc/resolv.conf:"
cat /etc/resolv.conf | sed 's/^/  /'

echo ""
echo "🧪 Test de résolution DNS:"
echo "  → google.com via:"
nslookup google.com | grep "Server:" | sed 's/^/    /'

echo ""
echo "================================================"
echo "Pour vérifier en ligne:"
echo "  → https://www.dnsleaktest.com/"
echo "  → https://1.1.1.1/help"
echo ""
echo "Pour désactiver la protection du resolv.conf:"
echo "  sudo chattr -i /etc/resolv.conf"
echo "================================================"
