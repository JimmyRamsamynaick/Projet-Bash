#!/bin/bash
#Utilisation : ./sauvegarde.sh
#Auteur : Jimmy, Sameer, Alexandre

#On récupère la date actuelle au format YYYY-MM-DD_HH-MM-SS
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

#Dossier ou fichier à sauvegarder
SOURCE="/home/jimmy/cours_expernet"

#Nom de l'archive compressée + la date
ARCHIVE_NAME="sauvegarde_$DATE.tar.gz"

#Répertoire local ou l'on va stocker les sauvegardes
DEST_LOCAL="/tmp"

#Création de l'archive compressée à partir du dossier source
tar -czf "$DEST_LOCAL/$ARCHIVE_NAME" "$SOURCE"

#Message de confirmation de création de l'archive
echo "Archive créée localement : $DEST_LOCAL/$ARCHIVE_NAME"

#Fin du script
echo "Sauvegarde terminée."

#Sauvegarde automatique tout les vendredis à 22H00
crontab -e
30 22 * * 5 /tmp