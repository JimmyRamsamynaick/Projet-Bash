#!/bin/bash
# Script : analyse_logs_apache.sh
# Auteurs : Jimmy RAMSAMYNAÏCK, Sameer VALI ADAM, Alexandre BADOUARD
# Date : $(date)

# Ce script analyse les fichiers de logs Apache et génère un rapport des erreurs fréquentes,
# des adresses IP suspectes et des statistiques d’accès.

# Vérification des droits root
if [ "$(id -u)" -ne 0 ]; then
    echo "Ce script doit être exécuté avec les droits root."
    exit 1
fi

# Définition des fichiers de log Apache à analyser
LOG_FILES=("/var/log/apache2/access.log" "/var/log/apache2/error.log")

# Vérification de la présence des fichiers de logs Apache
for LOG_FILE in "${LOG_FILES[@]}"; do
    if [ ! -f "$LOG_FILE" ]; then
        echo "Le fichier de log $LOG_FILE n'existe pas. Veuillez vérifier."
        exit 1
    fi
done

# Fichiers de sortie
REPORT_FILE="/tmp/log_analysis_apache_report.txt"
TEMP_REPORT="/tmp/temp_apache_report.txt"
SUSPICIOUS_IP_FILE="/tmp/apache_suspicious_ips.txt"
ERRORS_FILE="/tmp/apache_frequent_errors.txt"

# Réinitialisation
> "$REPORT_FILE"
> "$TEMP_REPORT"
> "$SUSPICIOUS_IP_FILE"
> "$ERRORS_FILE"

DATE_FORMAT=$(date +'%Y-%m-%d %H:%M:%S')
echo "Début de l'analyse des logs Apache à $DATE_FORMAT..."
START_TIME=$(date +%s)

# Analyse des fichiers de logs Apache
for LOG_FILE in "${LOG_FILES[@]}"; do
    echo "Analyse du fichier : $LOG_FILE"

    # Erreurs fréquentes (HTTP 4xx / 5xx)
    awk '{print $9}' "$LOG_FILE" | grep -E '^[45][0-9]{2}$' | sort | uniq -c | sort -nr >> "$ERRORS_FILE"

    # IP suspectes (plus de 100 requêtes)
    awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | awk '$1 > 100' >> "$SUSPICIOUS_IP_FILE"

    # Statistiques d’accès
    echo "Statistiques pour $LOG_FILE :" >> "$REPORT_FILE"
    awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
done

# Génération du rapport dans un fichier temporaire
{
    echo "Rapport d'analyse Apache - $(date)"
    echo "======================================"
    echo ""
    echo "Erreurs fréquentes :"
    cat "$ERRORS_FILE"
    echo ""
    echo "Adresses IP suspectes :"
    cat "$SUSPICIOUS_IP_FILE"
    echo ""
    echo "Statistiques générales :"
    cat "$REPORT_FILE"
} > "$TEMP_REPORT"

# Remplacement du fichier final par le rapport temporaire
mv "$TEMP_REPORT" "$REPORT_FILE"

# Vérification
if [ $? -eq 0 ]; then
    echo "Le rapport a été généré avec succès dans : $REPORT_FILE"
else
    echo "Erreur lors de la génération du rapport."
    exit 1
fi

# Résumé
echo
echo "Résumé de l'analyse :"
echo "Erreurs fréquentes détectées : $(wc -l < "$ERRORS_FILE")"
echo "Adresses IP suspectes : $(wc -l < "$SUSPICIOUS_IP_FILE")"
echo "Statistiques collectées : $(wc -l < "$REPORT_FILE") lignes"
END_TIME=$(date +%s)
echo "Durée d'exécution : $((END_TIME - START_TIME)) secondes"
echo "Fin de l'analyse des logs à $(date +'%Y-%m-%d %H:%M:%S')"
