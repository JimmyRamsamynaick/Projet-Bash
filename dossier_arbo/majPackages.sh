#!/bin/bash
# Surveillance des mises à jour de paquets APT
# Auteur : $USER

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
FICHIER_RAPPORT="maj_packages_$DATE.txt"

echo "Vérification des mises à jour disponibles (APT)..." > "$FICHIER_RAPPORT"
echo "Date : $(date)" >> "$FICHIER_RAPPORT"
echo "Utilisateur : $USER" >> "$FICHIER_RAPPORT"
echo "---------------------------------------------" >> "$FICHIER_RAPPORT"

# Mettre à jour les infos des paquets sans les installer
sudo apt update -qq

# Lister les paquets pouvant être mis à jour
apt list --upgradable 2>/dev/null >> "$FICHIER_RAPPORT"

echo "---------------------------------------------" >> "$FICHIER_RAPPORT"
echo "Rapport sauvegardé dans : $FICHIER_RAPPORT"

# (Optionnel) Affichage du rapport à l’écran
cat "$FICHIER_RAPPORT"
