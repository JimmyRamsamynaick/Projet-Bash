#!/bin/bash
#!/bin/bash
#Utilisation : ./optimisation.sh
#Auteur : Jimmy,Sameer,Alexandre

#Seuil d'alerte en pourcentage
SEUIL=20

#Point de montage à surveiller (ici, la racine "/")
PARTITION="/"

#On extrait le pourcentage d’utilisation de la partition (sans le %)
UTILISATION=$(df -h "$PARTITION" | awk 'NR==2 {gsub("%",""); print $5}')

#Affiche l’utilisation actuelle
echo "Utilisation actuelle de $PARTITION : $UTILISATION%"

#Si utilisation ≥ seuil, on déclenche une alerte
if [ "$UTILISATION" -ge "$SEUIL" ]; then
    echo " Attention : L'espace disque utilisé sur $PARTITION a atteint $UTILISATION% !"

    #Notification système (pour les environnements graphiques)
    if command -v notify-send &> /dev/null; then
        notify-send "Alerte disque" "Utilisation disque sur $PARTITION : $UTILISATION%" --urgency=critical
    fi

    #  Envoi d’un email mais requiert smtp
    # echo "Espace disque critique : $UTILISATION%" | mail -s "Alerte disque pleine" un@email.com
else
    echo "Espace disque normal."
fi
