#!/bin/bash

# =============================================================================
# SCRIPT SÉCURISÉ - MENU PRINCIPAL
# Version: 1.30-SECURE
# =============================================================================

set -euo pipefail  # Mode strict : arrêt sur erreur, variables non définies, échec de pipe
IFS=$'\n\t'        # Sécurisation de l'IFS (Internal Field Separator)

# Couleurs
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# Configuration sécurisée
readonly SCRIPT_DIR="/home/jimmy/projet_bash_final/Projet-Bash/dossier_arbo"
readonly SCRIPT_VERSION="1.30-SECURE"
readonly MAX_SCRIPT_NAME_LENGTH=50
readonly ALLOWED_CHARS="[a-zA-Z0-9._-]"

# Liste blanche des scripts autorisés (sécurité par défaut)
readonly -a ALLOWED_SCRIPTS=(
    "analysSSH.sh"
    "analyse_log.sh"
    "cleanFiles.sh"
    "disque.sh"
    "majPackages.sh"
    "optimisation.sh"
    "planificateur.sh"
    "rapport_sys.sh"
    "sauvegarde.sh"
    "synch_repertoire.sh"
    "templateGenerator.sh"
    "test_reseaux.sh"
)

# =============================================================================
# FONCTIONS DE SÉCURITÉ
# =============================================================================

# Fonction de logging sécurisé
log_security_event() {
    local event="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local user=$(whoami)
    local log_file="/var/log/script_security.log"
    
    # Tentative d'écriture dans le log système (si permissions disponibles)
    if [[ -w "/var/log" ]] || [[ -w "$log_file" ]]; then
        echo "[$timestamp] USER:$user EVENT:$event" >> "$log_file" 2>/dev/null || true
    fi
    
    # Log également dans le log utilisateur
    local user_log="$HOME/.script_security.log"
    echo "[$timestamp] EVENT:$event" >> "$user_log" 2>/dev/null || true
}

# Validation stricte du nom de script
validate_script_name() {
    local script_name="$1"
    
    # Vérification de la longueur
    if [[ ${#script_name} -gt $MAX_SCRIPT_NAME_LENGTH ]]; then
        log_security_event "SECURITY_VIOLATION: Script name too long: $script_name"
        return 1
    fi
    
    # Vérification des caractères autorisés
    if [[ ! "$script_name" =~ ^${ALLOWED_CHARS}+$ ]]; then
        log_security_event "SECURITY_VIOLATION: Invalid characters in script name: $script_name"
        return 1
    fi
    
    # Vérification qu'il n'y a pas de path traversal
    if [[ "$script_name" == *".."* ]] || [[ "$script_name" == *"/"* ]]; then
        log_security_event "SECURITY_VIOLATION: Path traversal attempt: $script_name"
        return 1
    fi
    
    # Vérification contre la liste blanche
    local allowed=false
    for allowed_script in "${ALLOWED_SCRIPTS[@]}"; do
        if [[ "$script_name" == "$allowed_script" ]]; then
            allowed=true
            break
        fi
    done
    
    if [[ "$allowed" == false ]]; then
        log_security_event "SECURITY_VIOLATION: Script not in whitelist: $script_name"
        return 1
    fi
    
    return 0
}

# Validation de l'entrée utilisateur
validate_user_input() {
    local input="$1"
    
    # Suppression des espaces
    input=$(echo "$input" | tr -d ' \t\n\r')
    
    # Vérification que c'est un nombre entre 0 et 13
    if [[ ! "$input" =~ ^[0-9]+$ ]] || [[ "$input" -lt 0 ]] || [[ "$input" -gt 13 ]]; then
        return 1
    fi
    
    echo "$input"
    return 0
}

# Vérification de l'intégrité du script
check_script_integrity() {
    local script_path="$1"
    
    # Vérification que le fichier existe et est lisible
    if [[ ! -f "$script_path" ]] || [[ ! -r "$script_path" ]]; then
        return 1
    fi
    
    # Vérification que le propriétaire est correct (optionnel)
    local file_owner=$(stat -c '%U' "$script_path" 2>/dev/null || echo "unknown")
    local current_user=$(whoami)
    
    # Vérification des permissions (pas d'écriture pour groupe/autres)
    local file_perms=$(stat -c '%a' "$script_path" 2>/dev/null || echo "000")
    if [[ "${file_perms:1:1}" -gt 5 ]] || [[ "${file_perms:2:1}" -gt 5 ]]; then
        log_security_event "SECURITY_WARNING: Script has write permissions for group/others: $script_path"
        return 1
    fi
    
    # Vérification de base du contenu (pas de caractères suspects)
    if grep -q $'\x00\|\x1b\[' "$script_path" 2>/dev/null; then
        log_security_event "SECURITY_WARNING: Script contains suspicious characters: $script_path"
        return 1
    fi
    
    return 0
}

# =============================================================================
# FONCTIONS D'AFFICHAGE (INCHANGÉES MAIS SÉCURISÉES)
# =============================================================================

show_header() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                                    ║${NC}"
    echo -e "${CYAN}║${WHITE}    ███╗   ██╗ ██████╗ ███████╗    ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗███████╗${CYAN}    ║${NC}"
    echo -e "${CYAN}║${WHITE}    ████╗  ██║██╔═══██╗██╔════╝    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝${CYAN}    ║${NC}"
    echo -e "${CYAN}║${GREEN}    ██╔██╗ ██║██║   ██║███████╗    ███████╗██║     ██████╔╝██║██████╔╝   ██║   ███████╗${CYAN}    ║${NC}"
    echo -e "${CYAN}║${GREEN}    ██║╚██╗██║██║   ██║╚════██║    ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ╚════██║${CYAN}    ║${NC}"
    echo -e "${CYAN}║${GREEN}    ██║ ╚████║╚██████╔╝███████║    ███████║╚██████╗██║  ██║██║██║        ██║   ███████║${CYAN}    ║${NC}"
    echo -e "${CYAN}║${WHITE}    ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ╚══════╝${CYAN}    ║${NC}"
    echo -e "${CYAN}║                                                                    ║${NC}"
    echo -e "${CYAN}║${RED}                               🔒 MODE SÉCURISÉ 🔒                          ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}                        🚀 Menu Principal des Scripts 🚀${NC}"
    echo -e "${PURPLE}                              Version ${SCRIPT_VERSION}${NC}"
    echo ""
}

show_menu() {
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                              📋 LISTE DES SCRIPTS                             ║${NC}"
    echo -e "${BLUE}╠═══════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BLUE}║${WHITE}  1.${NC}  🔍 ${YELLOW}analysSSH.sh${NC}           - Analyse des connexions SSH                ║"
    echo -e "${BLUE}║${WHITE}  2.${NC}  📊 ${YELLOW}analyse_log.sh${NC}         - Analyse des fichiers de logs             ║"
    echo -e "${BLUE}║${WHITE}  3.${NC}  🧹 ${YELLOW}cleanFiles.sh${NC}          - Nettoyage des fichiers temporaires       ║"
    echo -e "${BLUE}║${WHITE}  4.${NC}  💾 ${YELLOW}disque.sh${NC}              - Gestion et analyse des disques           ║"
    echo -e "${BLUE}║${WHITE}  5.${NC}  📦 ${YELLOW}majPackages.sh${NC}         - Mise à jour des packages                 ║"
    echo -e "${BLUE}║${WHITE}  6.${NC}  ⚡ ${YELLOW}optimisation.sh${NC}        - Optimisation du système                  ║"
    echo -e "${BLUE}║${WHITE}  7.${NC}  ⏰ ${YELLOW}planificateur.sh${NC}       - Planification des tâches                 ║"
    echo -e "${BLUE}║${WHITE}  8.${NC}  📈 ${YELLOW}rapport_sys.sh${NC}         - Génération de rapports système          ║"
    echo -e "${BLUE}║${WHITE}  9.${NC}  💾 ${YELLOW}sauvegarde.sh${NC}          - Sauvegarde des données                   ║"
    echo -e "${BLUE}║${WHITE} 10.${NC}  🔄 ${YELLOW}synch_repertoire.sh${NC}    - Synchronisation de répertoires           ║"
    echo -e "${BLUE}║${WHITE} 11.${NC}  📝 ${YELLOW}templateGenerator.sh${NC}   - Générateur de templates                   ║"
    echo -e "${BLUE}║${WHITE} 12.${NC}  🌐 ${YELLOW}test_reseaux.sh${NC}        - Test et diagnostic réseau                ║"
    echo -e "${BLUE}╠═══════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BLUE}║${WHITE} 13.${NC}  ❓ ${CYAN}Aide${NC}                    - Liste des commandes disponibles          ║"
    echo -e "${BLUE}╠═══════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BLUE}║${WHITE}  0.${NC}  🚪 ${RED}Quitter${NC}                 - Sortir du menu                           ║"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_help() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                  📚 AIDE                                      ║${NC}"
    echo -e "${CYAN}╠═══════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║                          Version des scripts: ${SCRIPT_VERSION}                     ║${NC}"
    echo -e "${CYAN}║                                🔒 MODE SÉCURISÉ 🔒                           ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                            🔐 AMÉLIORATIONS DE SÉCURITÉ                       ║${NC}"
    echo -e "${GREEN}╠═══════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║                                                                               ║${NC}"
    echo -e "${GREEN}║ • ${WHITE}Mode strict activé (set -euo pipefail)${NC}                                ║"
    echo -e "${GREEN}║ • ${WHITE}Validation stricte des noms de scripts${NC}                               ║"
    echo -e "${GREEN}║ • ${WHITE}Liste blanche des scripts autorisés${NC}                                  ║"
    echo -e "${GREEN}║ • ${WHITE}Protection contre l'injection de commandes${NC}                          ║"
    echo -e "${GREEN}║ • ${WHITE}Vérification d'intégrité des scripts${NC}                                 ║"
    echo -e "${GREEN}║ • ${WHITE}Logging des événements de sécurité${NC}                                  ║"
    echo -e "${GREEN}║ • ${WHITE}Protection contre le path traversal${NC}                                 ║"
    echo -e "${GREEN}║ • ${WHITE}Validation des permissions de fichiers${NC}                              ║"
    echo -e "${GREEN}║                                                                               ║"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                            🔧 COMMANDES DISPONIBLES                           ║${NC}"
    echo -e "${BLUE}╠═══════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BLUE}║                                                                               ║${NC}"
    echo -e "${BLUE}║ ${WHITE}🔍 analysSSH.sh${NC}           - Analyse les connexions SSH                    ║"
    echo -e "${BLUE}║ ${WHITE}📊 analyse_log.sh${NC}         - Analyse des fichiers de logs                 ║"
    echo -e "${BLUE}║ ${WHITE}🧹 cleanFiles.sh${NC}          - Nettoyage des fichiers temporaires           ║"
    echo -e "${BLUE}║ ${WHITE}💾 disque.sh${NC}              - Gestion et analyse des disques               ║"
    echo -e "${BLUE}║ ${WHITE}📦 majPackages.sh${NC}         - Mise à jour des packages                     ║"
    echo -e "${BLUE}║ ${WHITE}⚡ optimisation.sh${NC}        - Optimisation du système                      ║"
    echo -e "${BLUE}║ ${WHITE}⏰ planificateur.sh${NC}       - Planification des tâches                     ║"
    echo -e "${BLUE}║ ${WHITE}📈 rapport_sys.sh${NC}         - Génération de rapports système              ║"
    echo -e "${BLUE}║ ${WHITE}💾 sauvegarde.sh${NC}          - Sauvegarde des données                       ║"
    echo -e "${BLUE}║ ${WHITE}🔄 synch_repertoire.sh${NC}    - Synchronisation de répertoires               ║"
    echo -e "${BLUE}║ ${WHITE}📝 templateGenerator.sh${NC}   - Générateur de templates                       ║"
    echo -e "${BLUE}║ ${WHITE}🌐 test_reseaux.sh${NC}        - Test et diagnostic réseau                    ║"
    echo -e "${BLUE}║                                                                               ║"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${PURPLE}📋 Appuyez sur Entrée pour revenir au menu principal...${NC}"
    read -r
}

# =============================================================================
# FONCTION D'EXÉCUTION SÉCURISÉE
# =============================================================================

execute_script() {
    local script_name="$1"
    
    # Validation du nom de script
    if ! validate_script_name "$script_name"; then
        echo -e "${RED}❌ ERREUR DE SÉCURITÉ: Script non autorisé ou nom invalide: $script_name${NC}"
        log_security_event "EXECUTION_DENIED: $script_name"
        return 1
    fi
    
    # Construction du chemin sécurisé
    local script_path
    script_path=$(realpath "$SCRIPT_DIR/$script_name" 2>/dev/null) || {
        echo -e "${RED}❌ ERREUR: Impossible de résoudre le chemin du script${NC}"
        return 1
    }
    
    # Vérification que le chemin résolu est bien dans le répertoire autorisé
    local canonical_script_dir
    canonical_script_dir=$(realpath "$SCRIPT_DIR" 2>/dev/null) || {
        echo -e "${RED}❌ ERREUR: Impossible de résoudre le répertoire des scripts${NC}"
        return 1
    }
    
    if [[ "$script_path" != "$canonical_script_dir"/* ]]; then
        echo -e "${RED}❌ ERREUR DE SÉCURITÉ: Tentative d'accès hors du répertoire autorisé${NC}"
        log_security_event "PATH_TRAVERSAL_ATTEMPT: $script_path"
        return 1
    fi
    
    # Vérification de l'intégrité du script
    if ! check_script_integrity "$script_path"; then
        echo -e "${RED}❌ ERREUR DE SÉCURITÉ: Échec de la vérification d'intégrité${NC}"
        log_security_event "INTEGRITY_CHECK_FAILED: $script_path"
        return 1
    fi
    
    # Vérification de l'exécutabilité
    if [[ ! -x "$script_path" ]]; then
        echo -e "${YELLOW}⚠️  Le script $script_name n'est pas exécutable.${NC}"
        echo -e "${RED}❌ SÉCURITÉ: Refus de modifier les permissions automatiquement${NC}"
        echo -e "${BLUE}💡 Veuillez exécuter manuellement: chmod +x \"$script_path\"${NC}"
        return 1
    fi
    
    # Log de l'exécution
    log_security_event "SCRIPT_EXECUTION: $script_name by $(whoami)"
    
    echo -e "${GREEN}🚀 Exécution sécurisée de ${script_name}...${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════════════${NC}"
    
    # Exécution sécurisée du script
    if ! bash "$script_path"; then
        echo -e "${RED}❌ Le script $script_name s'est terminé avec une erreur${NC}"
        log_security_event "SCRIPT_ERROR: $script_name"
        return 1
    fi
    
    echo -e "${CYAN}════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ Script ${script_name} terminé avec succès.${NC}"
    
    return 0
}

# =============================================================================
# FONCTION PRINCIPALE SÉCURISÉE
# =============================================================================

main() {
    local choice
    local validated_choice
    
    # Vérification des prérequis de sécurité
    if [[ ! -d "$SCRIPT_DIR" ]]; then
        echo -e "${RED}❌ ERREUR: Le répertoire ${SCRIPT_DIR} n'existe pas.${NC}"
        echo -e "${YELLOW}💡 Veuillez vérifier le chemin et réessayer.${NC}"
        exit 1
    fi
    
    # Log du démarrage
    log_security_event "MENU_STARTED by $(whoami)"
    
    while true; do
        show_header
        show_menu
        
        echo -e "${WHITE}🎯 Choisissez une option (0-13): ${NC}"
        read -r choice
        
        # Validation de l'entrée utilisateur
        if ! validated_choice=$(validate_user_input "$choice"); then
            echo -e "${RED}❌ Option invalide. Veuillez choisir un nombre entre 0 et 13.${NC}"
            echo -e "${PURPLE}📋 Appuyez sur Entrée pour continuer...${NC}"
            read -r
            continue
        fi
        
        case $validated_choice in
            1)  execute_script "analysSSH.sh" ;;
            2)  execute_script "analyse_log.sh" ;;
            3)  execute_script "cleanFiles.sh" ;;
            4)  execute_script "disque.sh" ;;
            5)  execute_script "majPackages.sh" ;;
            6)  execute_script "optimisation.sh" ;;
            7)  execute_script "planificateur.sh" ;;
            8)  execute_script "rapport_sys.sh" ;;
            9)  execute_script "sauvegarde.sh" ;;
            10) execute_script "synch_repertoire.sh" ;;
            11) execute_script "templateGenerator.sh" ;;
            12) execute_script "test_reseaux.sh" ;;
            13) show_help ;;
            0)
                clear
                echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════╗${NC}"
                echo -e "${GREEN}║                                                                   ║${NC}"
                echo -e "${GREEN}║           🙏 Merci d'avoir utilisé Nos Scripts !                  ║${NC}"
                echo -e "${GREEN}║                                                                   ║${NC}"
                echo -e "${GREEN}║                        👋 À bientôt !                            ║${NC}"
                echo -e "${GREEN}║                                                                   ║${NC}"
                echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════╝${NC}"
                echo ""
                log_security_event "MENU_EXITED by $(whoami)"
                exit 0
                ;;
        esac
        
        echo ""
        echo -e "${PURPLE}📋 Appuyez sur Entrée pour revenir au menu principal...${NC}"
        read -r
    done
}

# =============================================================================
# POINT D'ENTRÉE PRINCIPAL
# =============================================================================

# Vérifications de sécurité au démarrage
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Vérification que le script n'est pas exécuté avec des arguments suspects
    if [[ $# -gt 0 ]]; then
        echo -e "${RED}❌ ERREUR DE SÉCURITÉ: Ce script ne doit pas être exécuté avec des arguments${NC}"
        log_security_event "SECURITY_VIOLATION: Script executed with arguments: $*"
        exit 1
    fi
    
    # Lancement du menu principal
    main
fi
