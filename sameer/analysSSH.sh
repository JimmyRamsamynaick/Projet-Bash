#!/bin/bash
# Analyse des connexions SSH
# Auteur : Fouarlic Industry

LOG="./faux_auth.log"
HEURE_SUSPECTE_DEBUT=0
HEURE_SUSPECTE_FIN=5
RAPPORT="rapport_ssh_$(date +%F_%H-%M).txt"

# Vérifier si le log existe
if [[ ! -f "$LOG" ]]; then
    echo "Fichier $LOG introuvable. Vérifie les permissions ou le nom du fichier."
    exit 1
fi

echo "Rapport d’analyse SSH — $(date)" > "$RAPPORT"
echo "Fichier analysé : $LOG" >> "$RAPPORT"
echo "--------------------------------------------" >> "$RAPPORT"

# 1. Liste des connexions réussies (Accepted)
echo -e "\nConnexions SSH réussies :" >> "$RAPPORT"
grep "Accepted" "$LOG" | awk '{print $1, $2, $3, $9, $11}' >> "$RAPPORT"

# 2. Utilisateurs ayant réussi à se connecter
echo -e "\nUtilisateurs connectés récemment :" >> "$RAPPORT"
grep "Accepted" "$LOG" | awk '{print $9}' | sort | uniq >> "$RAPPORT"

# 3. IP utilisées pour se connecter
echo -e "\nIP de connexion détectées :" >> "$RAPPORT"
grep "Accepted" "$LOG" | awk '{print $11}' | sort | uniq >> "$RAPPORT"

# 4. Connexions à des heures inhabituelles
echo -e "\nConnexions à des heures inhabituelles (entre $HEURE_SUSPECTE_DEBUT h et $HEURE_SUSPECTE_FIN h) :" >> "$RAPPORT"
grep "Accepted" "$LOG" | awk -v debut=$HEURE_SUSPECTE_DEBUT -v fin=$HEURE_SUSPECTE_FIN '
{
    split($3, t, ":");
    heure = t[1];
    if (heure + 0 >= debut && heure + 0 < fin) print $0;
}' >> "$RAPPORT"

# Affichage du rapport
echo -e "\nRapport généré : $RAPPORT"
cat "$RAPPORT"
