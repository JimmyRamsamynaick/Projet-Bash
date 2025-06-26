#!/bin/bash
# Nettoyeur de fichiers sensibles
# Auteur : Fouarlic Industry

# Répertoire à scanner
read -p "Répertoire à analyser (chemin absolu ou relatif) : " REPERTOIRE

# Dossier sécurisé pour déplacer les fichiers sensibles
SECURE_DIR="$HOME/fichiers_sensibles"

# Création du dossier sécurisé s’il n'existe pas
mkdir -p "$SECURE_DIR"

# Liste des extensions ou patterns sensibles
echo -e "\nRecherche de fichiers sensibles dans : $REPERTOIRE\n"

# Tableau temporaire
declare -a fichiers_trouves

# Recherche de fichiers nommés typiquement sensibles
while IFS= read -r fichier; do
    fichiers_trouves+=("$fichier")
done < <(find "$REPERTOIRE" -type f \( -name ".env" -o -name "id_rsa" -o -name "*secret*" -o -name "*password*" -o -iname "*.pem" -o -iname "*.key" \) 2>/dev/null)

# Recherche de contenu potentiellement dangereux (dans .log, .txt, .conf)
while IFS= read -r fichier; do
    if grep -qiE "(password|secret|PRIVATE KEY)" "$fichier"; then
        fichiers_trouves+=("$fichier")
    fi
done < <(find "$REPERTOIRE" -type f \( -iname "*.log" -o -iname "*.conf" -o -iname "*.txt" \) 2>/dev/null)

# Affichage des fichiers trouvés
if [ ${#fichiers_trouves[@]} -eq 0 ]; then
    echo "Aucun fichier sensible détecté."
    exit 0
else
    echo "Fichiers sensibles détectés :"
    for f in "${fichiers_trouves[@]}"; do
        echo " - $f"
    done
    echo
fi

# Demander s'il faut déplacer les fichiers dans le dossier sécurisé
read -p "Souhaitez-vous déplacer ces fichiers dans $SECURE_DIR ? (y/n) : " reponse

if [[ "$reponse" == "y" || "$reponse" == "Y" ]]; then
    for f in "${fichiers_trouves[@]}"; do
        mv "$f" "$SECURE_DIR" 2>/dev/null && echo "Déplacé : $f"
    done
    echo -e "\nTous les fichiers ont été déplacés dans : $SECURE_DIR"
else
    echo "Aucun fichier n’a été déplacé."
fi
