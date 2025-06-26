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
echo "Version : 1.1"
echo "Auteurs : Jimmy RAMSAMYNAÏCK, Sameer VALI ADAM, Alexandre BADOUARD"
echo

# Déclaration des variables
source=""
destination=""
mode=""

# ---------- MODE TEST INTÉGRÉ AUTOMATIQUE ----------
# Activé si aucun argument n’est fourni (pratique pour menu ou exécution directe)
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

# Lecture des arguments s’ils sont fournis
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
if [[ -z "$source" || -z "$destination" || -z "$mode" ]]; then
    echo "Erreur : paramètres manquants. Veuillez spécifier --source, --destination et --mode." >&2
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

# Vérification des outils requis
if ! command -v rsync &>/dev/null; then
    echo "Erreur : rsync n'est pas installé." >&2
    exit 1
fi

# Mode "intervalle" : exécution unique puis arrêt
if [[ "$mode" == "intervalle" ]]; then
    echo "Mode : intervalle (exécution unique)"
    echo "Synchronisation de $source vers $destination..."
    rsync -av --delete "$source/" "$destination/"
    if [[ $? -eq 0 ]]; then
        echo "✅ Synchronisation terminée avec succès à $(date)"
    else
        echo "❌ Erreur lors de la synchronisation." >&2
    fi
    exit 0
fi

# Mode "temps réel" : une seule synchronisation déclenchée par changement
if [[ "$mode" == "temps réel" ]]; then
    if ! command -v inotifywait &>/dev/null; then
        echo "Erreur : inotifywait est requis pour le mode temps réel." >&2
        exit 1
    fi
    echo "Mode : temps réel (en attente de modification dans $source pendant 60s)"
    inotifywait -r -e create,modify,delete "$source" -q -t 60
    if [[ $? -eq 0 ]]; then
        echo "Changement détecté. Lancement de la synchronisation..."
        rsync -av --delete "$source/" "$destination/"
        if [[ $? -eq 0 ]]; then
            echo "✅ Synchronisation effectuée avec succès à $(date)"
        else
            echo "❌ Échec de synchronisation." >&2
        fi
    else
        echo "⏳ Aucun changement détecté dans les 60 secondes. Fin du script."
    fi
    exit 0
fi
