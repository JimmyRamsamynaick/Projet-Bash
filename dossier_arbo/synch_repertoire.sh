#!/bin/bash
# Script : synch_repertoire.sh
# Auteurs : Jimmy RAMSAMYNAÏCK, Sameer VALI ADAM, Alexandre BADOUARD
# Date : $(date)

# =========================================================
# INSTALLATION DES PAQUETS NÉCESSAIRES (à faire une fois) :
# Décommenter les lignes ci-dessous si les paquets ne sont pas installés
# =========================================================
 sudo apt update
 sudo apt install -y rsync inotify-tools

# =========================================================
# DÉBUT DU SCRIPT DE SYNCHRONISATION DE RÉPERTOIRES
# Ce script utilise rsync ou inotifywait pour synchroniser
# deux dossiers (local-local ou local-distant)
# =========================================================

# Vérification des droits d'exécution du script
if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté avec les droits d'administrateur." >&2
    exit 1
fi

# Message d’accueil
echo "Bienvenue dans le script de synchronisation de répertoires !"
echo "Date et heure actuelles : $(date)"
echo "Version du script : 1.0"
echo "Auteur : Jimmy RAMSAMYNAÏCK, Sameer VALI ADAM, Alexandre BADOUARD"
echo "Ce script permet de synchroniser des répertoires locaux ou distants en utilisant rsync ou inotifywait."
echo
echo "Conditions d'utilisation :"
echo "1. Usage personnel ou professionnel uniquement."
echo "2. Utilisation commerciale avec autorisation."
echo
echo "Limitations de responsabilité :"
echo "Aucune responsabilité des auteurs en cas de perte de données."
echo
echo "Instructions :"
echo "./synch_repertoire.sh --source <source> --destination <destination> --mode <temps réel|intervalle>"
echo
echo "Exemples :"
echo "./synch_repertoire.sh --source /home/toto/src --destination /mnt/backup --mode intervalle"
echo "./synch_repertoire.sh --source /home/toto/src --destination user@serveur:/backup --mode temps réel"
echo
echo "Ressources requises : rsync, inotifywait (du paquet inotify-tools)"
echo

# Déclaration des variables
source=""
destination=""
mode=""

# Vérification des outils installés
if ! command -v rsync &>/dev/null; then
    echo "Erreur : rsync n'est pas installé." >&2
    exit 1
fi

# Vérification des arguments
if [[ $# -lt 6 ]]; then
    echo "Usage : $0 --source <chemin_source> --destination <chemin_destination> --mode <temps réel|intervalle>" >&2
    exit 1
fi

# Analyse des options
while [[ $# -gt 0 ]]; do
    case $1 in
        --source)
            source="$2"
            shift 2
            ;;
        --destination)
            destination="$2"
            shift 2
            ;;
        --mode)
            mode="$2"
            shift 2
            ;;
        *)
            echo "Option inconnue : $1" >&2
            exit 1
            ;;
    esac
done

# Validation des paramètres
if [[ -z "$source" || -z "$destination" ]]; then
    echo "Erreur : les chemins source et destination doivent être spécifiés." >&2
    exit 1
fi
if [[ "$mode" != "temps réel" && "$mode" != "intervalle" ]]; then
    echo "Erreur : le mode doit être 'temps réel' ou 'intervalle'." >&2
    exit 1
fi
if [[ ! -d "$source" ]]; then
    echo "Erreur : le répertoire source '$source' n'existe pas." >&2
    exit 1
fi
if [[ ! -d "$destination" && ! "$destination" =~ "@" ]]; then
    echo "Erreur : le répertoire destination '$destination' n'existe pas localement et ne semble pas distant." >&2
    exit 1
fi

# Mode intervalle
if [[ "$mode" == "intervalle" ]]; then
    echo "Mode 'intervalle défini' sélectionné."
    while true; do
        echo "Synchronisation en cours..."
        rsync -av --delete "$source/" "$destination/"
        echo "Synchronisation terminée à $(date)"
        sleep 60
    done
fi

# Mode temps réel
if [[ "$mode" == "temps réel" ]]; then
    echo "Mode 'temps réel' sélectionné."
    if ! command -v inotifywait &>/dev/null; then
        echo "Erreur : inotifywait est requis pour le mode temps réel." >&2
        exit 1
    fi
    inotifywait -m -r -e create,modify,delete "$source" | while read -r path action file; do
        echo "Changement détecté : $action sur $file dans $path"
        rsync -av --delete "$source/" "$destination/"
        echo "Synchronisation effectuée à $(date)"
    done
fi

# Fin du script
