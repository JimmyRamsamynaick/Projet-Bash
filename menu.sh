#!/bin/bash

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Répertoire des scripts
SCRIPT_DIR="/home/jimmy/projet_bash_final/Projet-Bash/dossier_arbo"

# Fonction pour afficher le header
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
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}                        🚀 Menu Principal des Scripts 🚀${NC}"
    echo ""
}

# Fonction pour afficher le menu
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
    echo -e "${BLUE}║${WHITE}  0.${NC}  🚪 ${RED}Quitter${NC}                 - Sortir du menu                           ║"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Fonction pour exécuter un script
execute_script() {
    local script_name=$1
    local script_path="${SCRIPT_DIR}/${script_name}"
    
    if [ -f "$script_path" ]; then
        if [ -x "$script_path" ]; then
            echo -e "${GREEN}🚀 Exécution de ${script_name}...${NC}"
            echo -e "${CYAN}════════════════════════════════════════════════════════════════════${NC}"
            
            # Exécution du script
            bash "$script_path"
            
            echo -e "${CYAN}════════════════════════════════════════════════════════════════════${NC}"
            echo -e "${GREEN}✅ Script ${script_name} terminé.${NC}"
        else
            echo -e "${YELLOW}⚠️  Le script ${script_name} n'est pas exécutable.${NC}"
            echo -e "${BLUE}💡 Tentative de correction des permissions...${NC}"
            chmod +x "$script_path"
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Permissions corrigées. Exécution du script...${NC}"
                bash "$script_path"
            else
                echo -e "${RED}❌ Impossible de corriger les permissions.${NC}"
            fi
        fi
    else
        echo -e "${RED}❌ Erreur: Le script ${script_name} n'existe pas dans ${SCRIPT_DIR}${NC}"
    fi
    
    echo ""
    echo -e "${PURPLE}📋 Appuyez sur Entrée pour revenir au menu principal...${NC}"
    read
}

# Fonction principale
main() {
    local choice
    
    while true; do
        show_header
        show_menu
        
        echo -e "${WHITE}🎯 Choisissez une option (0-12): ${NC}\c"
        read choice
        
        case $choice in
            1)
                execute_script "analysSSH.sh"
                ;;
            2)
                execute_script "analyse_log.sh"
                ;;
            3)
                execute_script "cleanFiles.sh"
                ;;
            4)
                execute_script "disque.sh"
                ;;
            5)
                execute_script "majPackages.sh"
                ;;
            6)
                execute_script "optimisation.sh"
                ;;
            7)
                execute_script "planificateur.sh"
                ;;
            8)
                execute_script "rapport_sys.sh"
                ;;
            9)
                execute_script "sauvegarde.sh"
                ;;
            10)
                execute_script "synch_repertoire.sh"
                ;;
            11)
                execute_script "templateGenerator.sh"
                ;;
            12)
                execute_script "test_reseaux.sh"
                ;;
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
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Option invalide. Veuillez choisir un nombre entre 0 et 12.${NC}"
                echo -e "${PURPLE}📋 Appuyez sur Entrée pour continuer...${NC}"
                read
                ;;
        esac
    done
}

# Vérification que le répertoire des scripts existe
if [ ! -d "$SCRIPT_DIR" ]; then
    echo -e "${RED}❌ Erreur: Le répertoire ${SCRIPT_DIR} n'existe pas.${NC}"
    echo -e "${YELLOW}💡 Veuillez vérifier le chemin et réessayer.${NC}"
    exit 1
fi

# Lancement du menu principal
main