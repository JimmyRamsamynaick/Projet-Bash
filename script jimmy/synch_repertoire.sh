#!/bin/bash
# Script : synch_repertoire.sh
# Auteurs : Jimmy RAMSAMYNAÏCK, Sameer VALI ADAM, Alexandre BADOUARD
# Date : $(date)

# =========================================================
# INSTALLATION DES PAQUETS NÉCESSAIRES (à faire une fois) :
# Décommenter les lignes ci-dessous si besoin
# =========================================================
# sudo apt update
# sudo apt install -y rsync inotify-tools

# =========================================================
# DÉBUT DU SCRIPT DE SYNCHRONISATION DE RÉPERTOIRES
# =========================================================

# Vérification des droits root
if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté avec les droits d'administrateur." >&2
    exit 1
fi

# Message d’accueil
echo "Bienvenue dans le script de synchronisation de répertoires !"
echo "Date : $(date)"
echo "Version : 1.0"
echo "Auteurs : Jimmy RAMSAMYNAÏCK, Sameer VALI ADAM, Alexandre BADOUARD"
echo
echo "Ce script synchronise deux répertoires locaux ou distants en utilisant rsync."
echo "Utilisation : ./synch_repertoire.sh --source <src> --destination <dest> --mode <temps réel|intervalle>"
echo

# Déclaration des variables
source=""
destination=""
mode=""

# ---------- MODE TEST INTÉGRÉ AUTOMATIQUE ----------
# Activé si aucun argument n’est fourni (idéal pour menu)
if [[ $# -eq 0 ]]; then
    echo "[TEST] Aucun argument fourni, mode test automatique activé."
    source="/tmp/source_test"
    destination="/tmp/dest_test"
    mode="intervalle"

    mkdir -p "$source"
    mkdir -p "$destination"
    echo "Fichier test A" > "$source/fichier_A.txt"
    echo "Fichier test B" > "$source/fichier_B.txt"

    echo "[TEST] Source : $source"
    echo "[TEST] Destination : $destination"
fi

# Vérification de rsync
if ! command -v rsync &>/dev/null; then
    echo "Erreur : rsync n'est pas installé." >&2
    exit 1
fi

# Lecture des arguments s’ils existent
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

# Validation des paramètres requis
if [[ -z "$source" || -z "$destination" || -z "$mode" ]]; then
    echo "Erreur : tous les paramètres --source, --destination et --mode sont requis." >&2
    exit 1
fi

if [[ ! -d "$source" ]]; then
    echo "Erreur : le répertoire source '$source' n'existe pas." >&2
    exit 1
fi

if [[ "$destination" != *"@"* && ! -d "$destination" ]]; then
    echo "Erreur : le répertoire destination '$destination' n'existe pas localement." >&2
    exit 1
fi

if [[ "$mode" != "intervalle" && "$mode" != "temps réel" ]]; then
    echo "Erreur : le mode doit être 'intervalle' ou 'temps réel'." >&2
    exit 1
fi

# --- Mode intervalle ---
if [[ "$mode" == "intervalle" ]]; then
    echo "Mode : intervalle défini (synchronisation toutes les 60 secondes)"
    while true; do
        echo ">> Synchronisation en cours..."
        rsync -av --delete "$source/" "$destination/"
        echo ">> Synchronisation terminée à $(date)"
        sleep 60
    done
fi

# --- Mode temps réel ---
if [[ "$mode" == "temps réel" ]]; then
    if ! command -v inotifywait &>/dev/null; then
        echo "Erreur : inotifywait est requis pour le mode temps réel. Installez inotify-tools." >&2
        exit 1
    fi
    echo "Mode : temps réel (détection continue avec inotify)"
    inotifywait -m -r -e create,modify,delete "$source" | while read -r path action file; do
        echo ">> Changement détecté : $action sur $file dans $path"
        rsync -av --delete "$source/" "$destination/"
        echo ">> Synchronisation effectuée à $(date)"
    done
fi

# Fin du script
