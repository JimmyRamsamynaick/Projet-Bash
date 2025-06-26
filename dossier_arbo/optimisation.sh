#!/bin/bash
#Utilisation : ./optimisation.sh
#Auteur : Jimmy,Sameer,Alexandre

# Affichage d'un titre clair
echo "Démarrage du nettoyeur intelligent de système..."

# Nettoyage des fichiers temporaires système
echo "➡️ Suppression des fichiers temporaires..."
sudo rm -rf /tmp/* /var/tmp/*  # Supprime les fichiers temporaires système

# Nettoyage du cache APT (pour Debian, Ubuntu, etc.)
echo "➡️ Nettoyage du cache APT..."
sudo apt-get clean            # Supprime tous les paquets téléchargés
sudo apt-get autoclean        # Supprime les paquets obsolètes

# Nettoyage des caches NPM (si NPM est installé)
if command -v npm &> /dev/null; then
  echo " Nettoyage du cache NPM..."
  npm cache clean --force
fi

# Nettoyage des fichiers .pyc (Python compilés)
echo " Suppression des fichiers Python compilés (.pyc)..."
find ~ -type f -name "*.pyc" -delete

# Détection et suppression des doublons (basé sur checksum MD5)
echo " Recherche de fichiers doublons dans le dossier personnel (~)..."
# On stocke temporairement les empreintes MD5
tempfile=$(mktemp)
find ~ -type f -exec md5sum {} + | sort | awk 'BEGIN{lasthash=""} $1==lasthash {print $2} {lasthash=$1}' > "$tempfile"

# Nettoyage terminé
rm -f "$tempfile"  # Supprime le fichier temporaire de travail
echo "Nettoyage terminé avec succès !"
