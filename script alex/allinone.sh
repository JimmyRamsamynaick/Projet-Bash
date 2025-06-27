#!/bin/bash
# Script d'Administration Système Unifié
# Auteurs : Jimmy RAMSAMYNAÏCK, Sameer VALI ADAM, Alexandre BADOUARD
# Date : $(date)
# Version : 2.0

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Variables globales
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="/tmp/admin_logs"
mkdir -p "$LOG_DIR"

# Fonction d'affichage du banner
afficher_banner() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${WHITE}                    SUITE D'ADMINISTRATION SYSTÈME                           ${CYAN}║${NC}"
    echo -e "${CYAN}║${WHITE}                     Version 2.0 - $(date +%Y)                                    ${CYAN}║${NC}"
    echo -e "${CYAN}║${WHITE}        Auteurs: Jimmy RAMSAMYNAÏCK, Sameer VALI ADAM, Alexandre BADOUARD   ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo
}

# Fonction d'affichage du menu principal
afficher_menu_principal() {
    echo -e "${WHITE}┌─────────────────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${WHITE}│${BLUE}                           MENU PRINCIPAL    (h pour aide)                  ${WHITE}│${NC}"
    echo -e "${WHITE}├─────────────────────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${WHITE}│ ${GREEN}1.${NC}  📊 Analyse des logs Apache                                          ${WHITE}│${NC}"
    echo -e "${WHITE}│ ${GREEN}2.${NC}  🔐 Analyse des connexions SSH                                       ${WHITE}│${NC}"
    echo -e "${WHITE}│ ${GREEN}3.${NC}  🧹 Nettoyeur de fichiers sensibles                                  ${WHITE}│${NC}"
    echo -e "${WHITE}│ ${GREEN}4.${NC}  💾 Surveillance de l'espace disque                                  ${WHITE}│${NC}"
    echo -e "${WHITE}│ ${GREEN}5.${NC}  📦 Vérification des mises à jour                                    ${WHITE}│${NC}"
    echo -e "${WHITE}│ ${GREEN}6.${NC}  🧽 Optimisation et nettoyage système                                ${WHITE}│${NC}"
    echo -e "${WHITE}│ ${GREEN}7.${NC}  ⏰ Planificateur de tâches                                          ${WHITE}│${NC}"
    echo -e "${WHITE}│ ${GREEN}8.${NC}  📋 Rapport système complet                                           ${WHITE}│${NC}"
    echo -e "${WHITE}│ ${GREEN}9.${NC}  💾 Sauvegarde de données                                             ${WHITE}│${NC}"
    echo -e "${WHITE}│ ${GREEN}10.${NC} 🔄 Synchronisation de répertoires                                   ${WHITE}│${NC}"
    echo -e "${WHITE}│ ${GREEN}11.${NC} 🏗️  Générateur de templates de projet                               ${WHITE}│${NC}"
    echo -e "${WHITE}│ ${GREEN}12.${NC} 🌐 Test de connectivité réseau                                      ${WHITE}│${NC}"
    echo -e "${WHITE}│ ${GREEN}0.${NC}  🚪 Quitter                                                           ${WHITE}│${NC}"
    echo -e "${WHITE}└─────────────────────────────────────────────────────────────────────────────┘${NC}"
    echo
}

# Fonction 1: Analyse des logs Apache
analyser_logs_apache() {
    echo -e "${YELLOW}📊 Analyse des logs Apache...${NC}"
    
    # Vérification des droits root
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}❌ Ce script doit être exécuté avec les droits root.${NC}"
        return 1
    fi

    # Définition des fichiers de log Apache
    LOG_FILES=("/var/log/apache2/access.log" "/var/log/apache2/error.log")
    
    # Vérification de la présence des fichiers
    for LOG_FILE in "${LOG_FILES[@]}"; do
        if [ ! -f "$LOG_FILE" ]; then
            echo -e "${RED}❌ Le fichier de log $LOG_FILE n'existe pas.${NC}"
            return 1
        fi
    done

    # Fichiers de sortie
    REPORT_FILE="$LOG_DIR/log_analysis_apache_report_$(date +%Y%m%d_%H%M%S).txt"
    SUSPICIOUS_IP_FILE="$LOG_DIR/apache_suspicious_ips.txt"
    ERRORS_FILE="$LOG_DIR/apache_frequent_errors.txt"

    # Réinitialisation
    > "$REPORT_FILE"
    > "$SUSPICIOUS_IP_FILE"
    > "$ERRORS_FILE"

    echo -e "${BLUE}🔍 Analyse en cours...${NC}"
    START_TIME=$(date +%s)

    # Analyse des fichiers de logs
    for LOG_FILE in "${LOG_FILES[@]}"; do
        echo "Analyse du fichier : $LOG_FILE"
        
        # Erreurs fréquentes (HTTP 4xx / 5xx)
        awk '{print $9}' "$LOG_FILE" 2>/dev/null | grep -E '^[45][0-9]{2}$' | sort | uniq -c | sort -nr >> "$ERRORS_FILE"
        
        # IP suspectes (plus de 100 requêtes)
        awk '{print $1}' "$LOG_FILE" 2>/dev/null | sort | uniq -c | sort -nr | awk '$1 > 100' >> "$SUSPICIOUS_IP_FILE"
    done

    # Génération du rapport
    {
        echo "Rapport d'analyse Apache - $(date)"
        echo "======================================"
        echo ""
        echo "Erreurs fréquentes :"
        cat "$ERRORS_FILE"
        echo ""
        echo "Adresses IP suspectes :"
        cat "$SUSPICIOUS_IP_FILE"
    } > "$REPORT_FILE"

    END_TIME=$(date +%s)
    echo -e "${GREEN}✅ Rapport généré avec succès : $REPORT_FILE${NC}"
    echo -e "${BLUE}⏱️  Durée d'exécution : $((END_TIME - START_TIME)) secondes${NC}"
    
    read -p "Appuyez sur Entrée pour continuer..."
}

# Fonction 2: Analyse des connexions SSH
analyser_ssh() {
    echo -e "${YELLOW}🔐 Analyse des connexions SSH...${NC}"
    
    LOG="/var/log/auth.log"
    if [ ! -f "$LOG" ]; then
        LOG="/var/log/secure"  # Pour CentOS/RHEL
        if [ ! -f "$LOG" ]; then
            echo -e "${RED}❌ Fichier de log SSH introuvable.${NC}"
            return 1
        fi
    fi

    HEURE_SUSPECTE_DEBUT=0
    HEURE_SUSPECTE_FIN=5
    RAPPORT="$LOG_DIR/rapport_ssh_$(date +%F_%H-%M).txt"

    echo -e "${BLUE}🔍 Analyse en cours...${NC}"
    
    {
        echo "Rapport d'analyse SSH — $(date)"
        echo "Fichier analysé : $LOG"
        echo "--------------------------------------------"
        
        echo -e "\nConnexions SSH réussies :"
        grep "Accepted" "$LOG" 2>/dev/null | awk '{print $1, $2, $3, $9, $11}' | tail -20
        
        echo -e "\nUtilisateurs connectés récemment :"
        grep "Accepted" "$LOG" 2>/dev/null | awk '{print $9}' | sort | uniq
        
        echo -e "\nIP de connexion détectées :"
        grep "Accepted" "$LOG" 2>/dev/null | awk '{print $11}' | sort | uniq
        
        echo -e "\nConnexions à des heures inhabituelles (entre ${HEURE_SUSPECTE_DEBUT}h et ${HEURE_SUSPECTE_FIN}h) :"
        grep "Accepted" "$LOG" 2>/dev/null | awk -v debut=$HEURE_SUSPECTE_DEBUT -v fin=$HEURE_SUSPECTE_FIN '
        {
            split($3, t, ":");
            heure = t[1];
            if (heure + 0 >= debut && heure + 0 < fin) print $0;
        }'
    } > "$RAPPORT"

    echo -e "${GREEN}✅ Rapport SSH généré : $RAPPORT${NC}"
    read -p "Appuyez sur Entrée pour continuer..."
}

# Fonction 3: Nettoyeur de fichiers sensibles
nettoyer_fichiers_sensibles() {
    echo -e "${YELLOW}🧹 Nettoyeur de fichiers sensibles...${NC}"
    
    read -p "Répertoire à analyser (chemin absolu ou relatif) : " REPERTOIRE
    
    if [ ! -d "$REPERTOIRE" ]; then
        echo -e "${RED}❌ Le répertoire spécifié n'existe pas.${NC}"
        return 1
    fi

    SECURE_DIR="$HOME/fichiers_sensibles_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$SECURE_DIR"

    echo -e "${BLUE}🔍 Recherche de fichiers sensibles dans : $REPERTOIRE${NC}"
    
    declare -a fichiers_trouves

    # Recherche de fichiers sensibles
    while IFS= read -r fichier; do
        fichiers_trouves+=("$fichier")
    done < <(find "$REPERTOIRE" -type f \( -name ".env" -o -name "id_rsa" -o -name "*secret*" -o -name "*password*" -o -iname "*.pem" -o -iname "*.key" \) 2>/dev/null)

    # Recherche de contenu sensible
    while IFS= read -r fichier; do
        if grep -qiE "(password|secret|PRIVATE KEY)" "$fichier" 2>/dev/null; then
            fichiers_trouves+=("$fichier")
        fi
    done < <(find "$REPERTOIRE" -type f \( -iname "*.log" -o -iname "*.conf" -o -iname "*.txt" \) 2>/dev/null)

    if [ ${#fichiers_trouves[@]} -eq 0 ]; then
        echo -e "${GREEN}✅ Aucun fichier sensible détecté.${NC}"
    else
        echo -e "${YELLOW}⚠️  Fichiers sensibles détectés :${NC}"
        for f in "${fichiers_trouves[@]}"; do
            echo -e "  ${RED}•${NC} $f"
        done
        
        echo
        read -p "Souhaitez-vous déplacer ces fichiers dans $SECURE_DIR ? (y/n) : " reponse
        
        if [[ "$reponse" == "y" || "$reponse" == "Y" ]]; then
            for f in "${fichiers_trouves[@]}"; do
                if mv "$f" "$SECURE_DIR" 2>/dev/null; then
                    echo -e "${GREEN}✅ Déplacé : $f${NC}"
                fi
            done
            echo -e "${GREEN}✅ Tous les fichiers ont été déplacés dans : $SECURE_DIR${NC}"
        else
            echo -e "${BLUE}ℹ️  Aucun fichier n'a été déplacé.${NC}"
        fi
    fi
    
    read -p "Appuyez sur Entrée pour continuer..."
}

# Fonction 4: Surveillance de l'espace disque
surveiller_disque() {
    echo -e "${YELLOW}💾 Surveillance de l'espace disque...${NC}"
    
    SEUIL=80
    PARTITION="/"
    
    UTILISATION=$(df -h "$PARTITION" | awk 'NR==2 {gsub("%",""); print $5}')
    
    echo -e "${BLUE}📊 Utilisation actuelle de $PARTITION : ${WHITE}$UTILISATION%${NC}"
    
    if [ "$UTILISATION" -ge "$SEUIL" ]; then
        echo -e "${RED}⚠️  ATTENTION : L'espace disque utilisé sur $PARTITION a atteint $UTILISATION% !${NC}"
        
        if command -v notify-send &> /dev/null; then
            notify-send "Alerte disque" "Utilisation disque sur $PARTITION : $UTILISATION%" --urgency=critical
        fi
    else
        echo -e "${GREEN}✅ Espace disque normal.${NC}"
    fi
    
    echo -e "${BLUE}📈 Détails des partitions :${NC}"
    df -h
    
    read -p "Appuyez sur Entrée pour continuer..."
}

# Fonction 5: Vérification des mises à jour
verifier_maj() {
    echo -e "${YELLOW}📦 Vérification des mises à jour...${NC}"
    
    FICHIER_RAPPORT="$LOG_DIR/maj_packages_$(date +%Y-%m-%d_%H-%M-%S).txt"
    
    {
        echo "Vérification des mises à jour disponibles (APT)..."
        echo "Date : $(date)"
        echo "Utilisateur : $USER"
        echo "---------------------------------------------"
    } > "$FICHIER_RAPPORT"
    
    echo -e "${BLUE}🔄 Mise à jour des informations des paquets...${NC}"
    if command -v apt &> /dev/null; then
        sudo apt update -qq
        apt list --upgradable 2>/dev/null >> "$FICHIER_RAPPORT"
    elif command -v yum &> /dev/null; then
        yum check-update >> "$FICHIER_RAPPORT" 2>&1
    else
        echo "Gestionnaire de paquets non supporté" >> "$FICHIER_RAPPORT"
    fi
    
    echo "---------------------------------------------" >> "$FICHIER_RAPPORT"
    echo "Rapport sauvegardé dans : $FICHIER_RAPPORT" >> "$FICHIER_RAPPORT"
    
    echo -e "${GREEN}✅ Rapport généré : $FICHIER_RAPPORT${NC}"
    cat "$FICHIER_RAPPORT"
    
    read -p "Appuyez sur Entrée pour continuer..."
}

# Fonction 6: Optimisation système
optimiser_systeme() {
    echo -e "${YELLOW}🧽 Optimisation et nettoyage système...${NC}"
    
    echo -e "${BLUE}🗑️  Suppression des fichiers temporaires...${NC}"
    sudo rm -rf /tmp/* /var/tmp/* 2>/dev/null
    
    if command -v apt-get &> /dev/null; then
        echo -e "${BLUE}🧹 Nettoyage du cache APT...${NC}"
        sudo apt-get clean
        sudo apt-get autoclean
    fi
    
    if command -v npm &> /dev/null; then
        echo -e "${BLUE}📦 Nettoyage du cache NPM...${NC}"
        npm cache clean --force 2>/dev/null
    fi
    
    echo -e "${BLUE}🐍 Suppression des fichiers Python compilés (.pyc)...${NC}"
    find ~ -type f -name "*.pyc" -delete 2>/dev/null
    
    echo -e "${GREEN}✅ Nettoyage terminé avec succès !${NC}"
    
    read -p "Appuyez sur Entrée pour continuer..."
}

# Fonction 7: Planificateur de tâches
planificateur_taches() {
    echo -e "${YELLOW}⏰ Planificateur de tâches...${NC}"
    
    while true; do
        echo -e "${WHITE}┌─────────────────────────────────────────┐${NC}"
        echo -e "${WHITE}│${BLUE}        PLANIFICATEUR DE TÂCHES          ${WHITE}│${NC}"
        echo -e "${WHITE}├─────────────────────────────────────────┤${NC}"
        echo -e "${WHITE}│ ${GREEN}1.${NC} Ajouter une tâche                    ${WHITE}│${NC}"
        echo -e "${WHITE}│ ${GREEN}2.${NC} Afficher les tâches                  ${WHITE}│${NC}"
        echo -e "${WHITE}│ ${GREEN}3.${NC} Vider le crontab                     ${WHITE}│${NC}"
        echo -e "${WHITE}│ ${GREEN}0.${NC} Retour au menu principal             ${WHITE}│${NC}"
        echo -e "${WHITE}└─────────────────────────────────────────┘${NC}"
        
        read -p "Votre choix : " choix_cron
        
        case $choix_cron in
            1)
                read -p "Entrez la commande ou le chemin complet du script : " commande
                
                echo "Choisissez la fréquence :"
                echo "1) Toutes les minutes"
                echo "2) Toutes les heures"
                echo "3) Tous les jours"
                echo "4) Tous les lundis"
                echo "5) Tous les mois"
                echo "6) Personnalisé"
                
                read -p "Votre choix : " freq_choix
                
                case $freq_choix in
                    1) cron_time="* * * * *" ;;
                    2) cron_time="0 * * * *" ;;
                    3) cron_time="0 0 * * *" ;;
                    4) cron_time="0 0 * * 1" ;;
                    5) cron_time="0 0 1 * *" ;;
                    6) read -p "Entrez votre expression cron : " cron_time ;;
                    *) echo "Choix invalide."; continue ;;
                esac
                
                read -p "Description de la tâche : " description
                (crontab -l 2>/dev/null; echo "# $description"; echo "$cron_time $commande") | crontab -
                echo -e "${GREEN}✅ Tâche ajoutée au crontab.${NC}"
                ;;
            2)
                echo -e "${BLUE}📋 Tâches actuellement planifiées :${NC}"
                crontab -l 2>/dev/null || echo "Aucune tâche planifiée."
                ;;
            3)
                read -p "Êtes-vous sûr de vouloir supprimer toutes les tâches ? (o/n) : " confirm
                if [[ "$confirm" == "o" ]]; then
                    crontab -r 2>/dev/null
                    echo -e "${GREEN}✅ Crontab vidé.${NC}"
                fi
                ;;
            0) return ;;
            *) echo -e "${RED}❌ Choix invalide.${NC}" ;;
        esac
        
        read -p "Appuyez sur Entrée pour continuer..."
    done
}

# Fonction 8: Rapport système
generer_rapport_systeme() {
    echo -e "${YELLOW}📋 Génération du rapport système...${NC}"
    
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}❌ Ce script doit être exécuté avec les droits root.${NC}"
        return 1
    fi

    DEST_DIR="$LOG_DIR/rapports"
    mkdir -p "$DEST_DIR"
    
    DATE_TAG=$(date +%Y%m%d_%H%M%S)
    REPORT_FILE="$DEST_DIR/rapport_systeme_${DATE_TAG}.txt"
    
    echo -e "${BLUE}📊 Collecte des informations système...${NC}"
    
    {
        echo "===== INFORMATIONS SYSTÈME ====="
        echo "OS : $(uname -s)"
        echo "Version : $(uname -r)"
        echo "Architecture : $(uname -m)"
        echo "Uptime : $(uptime -p 2>/dev/null || uptime)"
        echo ""

        echo "===== UTILISATION CPU ====="
        top -b -n1 | grep "Cpu(s)" 2>/dev/null || echo "Information CPU non disponible"
        echo ""

        echo "===== MÉMOIRE ====="
        free -h
        echo ""

        echo "===== DISQUES ====="
        df -h
        echo ""

        echo "===== SERVICES ACTIFS ====="
        if command -v systemctl &> /dev/null; then
            systemctl list-units --type=service --state=running 2>/dev/null | head -20
        else
            echo "systemctl non disponible"
        fi
        echo ""

        echo "===== RÉSEAU ====="
        echo "Adresse IP : $(hostname -I 2>/dev/null | awk '{print $1}' || echo 'Non disponible')"
        echo "Nom d'hôte : $(hostname)"
        echo ""

        echo "===== UTILISATEURS ET PROCESSUS ====="
        echo "Utilisateurs connectés :"
        who 2>/dev/null || echo "Information non disponible"
        echo ""
        echo "Top 10 processus mémoire :"
        ps aux --sort=-%mem 2>/dev/null | head -n 10 || echo "Information non disponible"
    } > "$REPORT_FILE"

    echo -e "${GREEN}✅ Rapport généré : $REPORT_FILE${NC}"
    
    read -p "Appuyez sur Entrée pour continuer..."
}

# Fonction 9: Sauvegarde
sauvegarder_donnees() {
    echo -e "${YELLOW}💾 Sauvegarde de données...${NC}"
    
    read -p "Dossier source à sauvegarder : " SOURCE
    
    if [ ! -d "$SOURCE" ]; then
        echo -e "${RED}❌ Le dossier source n'existe pas.${NC}"
        return 1
    fi

    DATE=$(date +"%Y-%m-%d_%H-%M-%S")
    ARCHIVE_NAME="sauvegarde_$DATE.tar.gz"
    DEST_LOCAL="$LOG_DIR"
    
    echo -e "${BLUE}📦 Création de l'archive...${NC}"
    
    if tar -czf "$DEST_LOCAL/$ARCHIVE_NAME" "$SOURCE" 2>/dev/null; then
        echo -e "${GREEN}✅ Archive créée : $DEST_LOCAL/$ARCHIVE_NAME${NC}"
        echo -e "${BLUE}📊 Taille de l'archive : $(du -h "$DEST_LOCAL/$ARCHIVE_NAME" | cut -f1)${NC}"
    else
        echo -e "${RED}❌ Erreur lors de la création de l'archive.${NC}"
    fi
    
    read -p "Appuyez sur Entrée pour continuer..."
}

# Fonction 10: Synchronisation de répertoires
synchroniser_repertoires() {
    echo -e "${YELLOW}🔄 Synchronisation de répertoires...${NC}"
    
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}❌ Ce script doit être exécuté avec les droits root.${NC}"
        return 1
    fi

    if ! command -v rsync &>/dev/null; then
        echo -e "${RED}❌ rsync n'est pas installé.${NC}"
        return 1
    fi

    read -p "Répertoire source : " source
    read -p "Répertoire destination : " destination
    
    if [[ ! -d "$source" ]]; then
        echo -e "${RED}❌ Le répertoire source n'existe pas.${NC}"
        return 1
    fi

    echo "Choisissez le mode :"
    echo "1) Synchronisation unique"
    echo "2) Synchronisation continue (Ctrl+C pour arrêter)"
    
    read -p "Votre choix : " mode_sync
    
    case $mode_sync in
        1)
            echo -e "${BLUE}🔄 Synchronisation en cours...${NC}"
            if rsync -av --delete "$source/" "$destination/"; then
                echo -e "${GREEN}✅ Synchronisation terminée.${NC}"
            else
                echo -e "${RED}❌ Erreur lors de la synchronisation.${NC}"
            fi
            ;;
        2)
            echo -e "${BLUE}🔄 Synchronisation continue activée...${NC}"
            while true; do
                rsync -av --delete "$source/" "$destination/"
                echo -e "${GREEN}✅ Synchronisation effectuée à $(date)${NC}"
                sleep 60
            done
            ;;
        *)
            echo -e "${RED}❌ Choix invalide.${NC}"
            ;;
    esac
    
    read -p "Appuyez sur Entrée pour continuer..."
}

# Fonction 11: Générateur de templates
generer_templates() {
    echo -e "${YELLOW}🏗️ Générateur de templates de projet...${NC}"
    
    while true; do
        echo -e "${WHITE}┌─────────────────────────────────────────┐${NC}"
        echo -e "${WHITE}│${BLUE}      GÉNÉRATEUR DE TEMPLATES            ${WHITE}│${NC}"
        echo -e "${WHITE}├─────────────────────────────────────────┤${NC}"
        echo -e "${WHITE}│ ${GREEN}1.${NC} Projet Site HTML                     ${WHITE}│${NC}"
        echo -e "${WHITE}│ ${GREEN}2.${NC} Projet Bash                          ${WHITE}│${NC}"
        echo -e "${WHITE}│ ${GREEN}0.${NC} Retour au menu principal             ${WHITE}│${NC}"
        echo -e "${WHITE}└─────────────────────────────────────────┘${NC}"
        
        read -p "Votre choix : " choix_template
        
        case $choix_template in
            1)
                read -p "Nom du projet HTML : " nom_projet
                mkdir -p "$nom_projet/css" "$nom_projet/js"

                cat > "$nom_projet/index.html" <<EOF
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$nom_projet</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h1>Bienvenue sur le projet $nom_projet</h1>
    <script src="js/script.js"></script>
</body>
</html>
EOF

                echo "/* Styles pour $nom_projet */" > "$nom_projet/css/style.css"
                echo "// Scripts pour $nom_projet" > "$nom_projet/js/script.js"
                echo "# $nom_projet" > "$nom_projet/README.md"

                echo -e "${GREEN}✅ Projet HTML '$nom_projet' créé avec succès !${NC}"
                ;;
            2)
                read -p "Nom du projet Bash : " nom_projet
                mkdir -p "$nom_projet/scripts" "$nom_projet/docs"

                cat > "$nom_projet/scripts/main.sh" <<EOF
#!/bin/bash
# Script principal du projet $nom_projet
# Auteur : $USER

echo "Bienvenue dans le projet $nom_projet"
EOF

                chmod +x "$nom_projet/scripts/main.sh"
                echo "# $nom_projet" > "$nom_projet/README.md"

                echo -e "${GREEN}✅ Projet Bash '$nom_projet' créé avec succès !${NC}"
                ;;
            0) return ;;
            *) echo -e "${RED}❌ Choix invalide.${NC}" ;;
        esac
        
        read -p "Appuyez sur Entrée pour continuer..."
    done
}

# Fonction 12: Test réseau
tester_reseau() {
    echo -e "${YELLOW}🌐 Test de connectivité réseau...${NC}"
    
    LOG_FILE="$LOG_DIR/network_test_results_$(date +%Y%m%d_%H%M%S).log"
    
    echo -e "${BLUE}🔍 Test de connectivité...${NC}"
    
    SERVERS=("google.com" "github.com" "cloudflare.com")
    
    {
        echo "Test de connectivité réseau - $(date)"
        echo "---------------------------------"
        echo "Résultats du ping :"
        
        for SERVER in "${SERVERS[@]}"; do
            echo "Test de $SERVER..."
            if ping -c 4 "$SERVER" >/dev/null 2>&1; then
                echo "✅ $SERVER est accessible"
            else
                echo "❌ $SERVER n'est pas accessible"
            fi
        done
        
        echo ""
        echo "Test des ports locaux :"
        
        PORTS=(22 80 443)
        for PORT in "${PORTS[@]}"; do
            if command -v nc &> /dev/null; then
                if nc -zv localhost "$PORT" >/dev/null 2>&1; then
                    echo "✅ Port $PORT ouvert"
                else
                    echo "❌ Port $PORT fermé"
                fi
            else
                echo "⚠️  nc (netcat) non disponible pour tester le port $PORT"
            fi
        done
        
    } | tee "$LOG_FILE"

echo ""
    echo -e "${GREEN}✅ Résultats sauvegardés dans : $LOG_FILE${NC}"
    
    # Test de résolution DNS
    echo -e "${BLUE}🔍 Test de résolution DNS...${NC}"
    echo "" >> "$LOG_FILE"
    echo "Test de résolution DNS - $(date)" >> "$LOG_FILE"
    echo "---------------------------------" >> "$LOG_FILE"
    
    for SERVER in "${SERVERS[@]}"; do
        if nslookup "$SERVER" >/dev/null 2>&1; then
            echo "✅ Résolution DNS de $SERVER réussie" | tee -a "$LOG_FILE"
        else
            echo "❌ Échec de résolution DNS de $SERVER" | tee -a "$LOG_FILE"
        fi
    done
    
    # Affichage des informations réseau
    echo -e "${BLUE}🌐 Informations réseau actuelles :${NC}"
    echo "" >> "$LOG_FILE"
    echo "Informations réseau - $(date)" >> "$LOG_FILE"
    echo "-----------------------------" >> "$LOG_FILE"
    
    if command -v ip &> /dev/null; then
        echo "Interfaces réseau :" | tee -a "$LOG_FILE"
        ip addr show | grep -E "inet |UP|DOWN" | tee -a "$LOG_FILE"
    else
        echo "Configuration réseau :" | tee -a "$LOG_FILE"
        ifconfig 2>/dev/null | grep -E "inet |UP|DOWN" | tee -a "$LOG_FILE"
    fi
    
    echo "" | tee -a "$LOG_FILE"
    echo "Table de routage :" | tee -a "$LOG_FILE"
    if command -v ip &> /dev/null; then
        ip route | head -10 | tee -a "$LOG_FILE"
    else
        route -n 2>/dev/null | tee -a "$LOG_FILE"
    fi
    
    read -p "Appuyez sur Entrée pour continuer..."
}

# Fonction d'aide
afficher_aide() {
    echo -e "${YELLOW}📚 Aide du script d'administration${NC}"
    echo
    echo -e "${WHITE}Ce script propose les fonctionnalités suivantes :${NC}"
    echo
    echo -e "${GREEN}1. Analyse des logs Apache${NC} - Analyse les fichiers de logs pour détecter les erreurs et les IP suspectes"
    echo -e "${GREEN}2. Analyse des connexions SSH${NC} - Surveille les connexions SSH et détecte les activités suspectes"
    echo -e "${GREEN}3. Nettoyeur de fichiers sensibles${NC} - Recherche et sécurise les fichiers contenant des informations sensibles"
    echo -e "${GREEN}4. Surveillance de l'espace disque${NC} - Monitore l'utilisation de l'espace disque"
    echo -e "${GREEN}5. Vérification des mises à jour${NC} - Vérifie les mises à jour disponibles pour le système"
    echo -e "${GREEN}6. Optimisation système${NC} - Nettoie les fichiers temporaires et optimise le système"
    echo -e "${GREEN}7. Planificateur de tâches${NC} - Gère les tâches cron"
    echo -e "${GREEN}8. Rapport système${NC} - Génère un rapport complet du système"
    echo -e "${GREEN}9. Sauvegarde de données${NC} - Crée des archives de sauvegarde"
    echo -e "${GREEN}10. Synchronisation de répertoires${NC} - Synchronise des répertoires avec rsync"
    echo -e "${GREEN}11. Générateur de templates${NC} - Crée des structures de projets"
    echo -e "${GREEN}12. Test de connectivité réseau${NC} - Teste la connectivité réseau et DNS"
    echo
    echo -e "${YELLOW}Tous les rapports sont sauvegardés dans : $LOG_DIR${NC}"
    echo
    read -p "Appuyez sur Entrée pour continuer..."
}

# Fonction de vérification des prérequis
verifier_prerequis() {
    echo -e "${BLUE}🔍 Vérification des prérequis...${NC}"
    
    local erreurs=0
    
    # Vérification des commandes essentielles
    local commandes_requises=("awk" "grep" "find" "tar" "df")
    
    for cmd in "${commandes_requises[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            echo -e "${RED}❌ Commande manquante : $cmd${NC}"
            ((erreurs++))
        fi
    done
    
    # Vérification des permissions d'écriture
    if [ ! -w "$LOG_DIR" ]; then
        echo -e "${RED}❌ Impossible d'écrire dans le répertoire de logs : $LOG_DIR${NC}"
        ((erreurs++))
    fi
    
    if [ $erreurs -eq 0 ]; then
        echo -e "${GREEN}✅ Tous les prérequis sont satisfaits${NC}"
        return 0
    else
        echo -e "${RED}❌ $erreurs erreur(s) détectée(s). Certaines fonctionnalités peuvent ne pas fonctionner.${NC}"
        return 1
    fi
}

# Fonction de nettoyage à la sortie
cleanup() {
    echo
    echo -e "${YELLOW}🧹 Nettoyage en cours...${NC}"
    
    # Suppression des fichiers temporaires créés par le script
    find "$LOG_DIR" -name "*.tmp" -mtime +1 -delete 2>/dev/null
    
    echo -e "${GREEN}✅ Script terminé proprement${NC}"
    echo -e "${BLUE}📁 Les rapports sont disponibles dans : $LOG_DIR${NC}"
    exit 0
}

# Gestionnaire de signaux
trap cleanup EXIT INT TERM

# Fonction principale
main() {
    # Vérification des prérequis au démarrage
    if ! verifier_prerequis; then
        read -p "Continuer malgré les erreurs ? (y/n) : " continuer
        if [[ "$continuer" != "y" && "$continuer" != "Y" ]]; then
            echo -e "${RED}❌ Arrêt du script${NC}"
            exit 1
        fi
    fi
    
    # Boucle principale du menu
    while true; do
        afficher_banner
        afficher_menu_principal
        
        read -p "$(echo -e ${WHITE}Choisissez une option ${BLUE}[0-12]${WHITE} : ${NC})" choix
        
        case $choix in
            1)
                analyser_logs_apache
                ;;
            2)
                analyser_ssh
                ;;
            3)
                nettoyer_fichiers_sensibles
                ;;
            4)
                surveiller_disque
                ;;
            5)
                verifier_maj
                ;;
            6)
                optimiser_systeme
                ;;
            7)
                planificateur_taches
                ;;
            8)
                generer_rapport_systeme
                ;;
            9)
                sauvegarder_donnees
                ;;
            10)
                synchroniser_repertoires
                ;;
            11)
                generer_templates
                ;;
            12)
                tester_reseau
                ;;
            "h"|"help"|"aide")
                afficher_aide
                ;;
            0|"q"|"quit"|"exit")
                clear
                echo -e "${GREEN}🚪 Au revoir !${NC}"
                cleanup
                ;;
            *)
                echo -e "${RED}❌ Choix invalide. Utilisez 'h' pour l'aide.${NC}"
                sleep 2
                ;;
        esac
    done
}

# Vérification si le script est exécuté directement
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Vérification de la version de Bash
    if [ "${BASH_VERSION%%.*}" -lt 4 ]; then
        echo -e "${RED}❌ Bash version 4.0+ requis. Version actuelle : $BASH_VERSION${NC}"
        exit 1
    fi
    
    # Message de bienvenue
    echo -e "${CYAN}🚀 Démarrage du script d'administration système...${NC}"
    sleep 1
    
    # Lancement du programme principal
    main "$@"
fi

# Fin du script
echo -e "${GREEN}✨ Script d'administration système terminé${NC}"
