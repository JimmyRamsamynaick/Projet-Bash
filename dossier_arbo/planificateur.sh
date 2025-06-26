#!/bin/bash
#utilisation : ./planificateur.sh
#Auteur: Jimmy,Sameer,Alex

# Titre du script
echo "=== Planificateur de tâches simplifié ==="

# Fonction pour ajouter une tâche dans le crontab
ajouter_tache() {
    # Demande la commande ou le chemin du script
    read -p "Entrez la commande ou le chemin complet du script à exécuter : " commande

    # Menu des fréquences
    echo "Choisissez la fréquence d’exécution :"
    select frequence in "Toutes les minutes" "Toutes les heures" "Tous les jours" "Tous les lundis" "Tous les mois" "Personnalisé (expression cron)" "Annuler"; do
        case $REPLY in
            1) cron_time="* * * * *"; break ;;
            2) cron_time="0 * * * *"; break ;;
            3) cron_time="0 0 * * *"; break ;;
            4) cron_time="0 0 * * 1"; break ;;
            5) cron_time="0 0 1 * *"; break ;;
            6) 
                read -p "Entrez votre expression cron personnalisée (ex: 30 22 * * 5) : " cron_time
                break ;;
            7) echo "Tâche annulée."; return ;;
            *) echo "Choix invalide." ;;
        esac
    done

    # Demande une description/commentaire pour la tâche
    read -p "Entrez une description pour cette tâche (visible dans le crontab) : " description

    # Ajout dans le crontab actuel
    (crontab -l 2>/dev/null; echo "# $description"; echo "$cron_time $commande") | crontab -

    echo "Tâche ajoutée au crontab."
}

# Fonction pour afficher les tâches existantes dans le crontab
afficher_taches() {
    echo "=== Tâches actuellement planifiées ==="
    crontab -l
    echo "======================================"
}

# Fonction pour vider entièrement le crontab
vider_crontab() {
    read -p "Êtes-vous sûr de vouloir supprimer toutes les tâches ? (o/n) : " confirm
    if [[ "$confirm" == "o" ]]; then
        crontab -r
        echo "Crontab vidé."
    else
        echo "Suppression annulée."
    fi
}

# Menu principal en boucle
while true; do
    echo ""
    echo "Que souhaitez-vous faire ?"
    select choix in "Ajouter une tâche" "Afficher les tâches" "Vider le crontab" "Quitter"; do
        case $REPLY in
            1) ajouter_tache; break ;;
            2) afficher_taches; break ;;
            3) vider_crontab; break ;;
            4) echo "Fin du programme."; exit 0 ;;
            *) echo "Choix invalide." ;;
        esac
    done
done
