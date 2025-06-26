#!/bin/bash
# Script : projet.sh
# Auteur : Jimmy RAMSAMYNAÏCK, Sameer VALI ADAM, Alexandre BADOUARD
# Date : $(date)

#3. Script de test réseau
#Un outil en ligne de commande qui vérifie la connectivité
#ping de plusieurs serveurs,
#test de vitesse réseau avec iperf,
#vérification de ports ouverts via nc.

# Ce script est conçu pour tester la connectivité réseau, la vitesse et les ports ouverts.
# Début du script de test réseau

# Vérification de la connectivité via ping sur plusieurs serveurs
# Vérification si ping est installé
if ! command -v ping &> /dev/null; then
    echo "ping is not installed. Please install it to run the connectivity test."
    exit 1
fi

# Affichage d'un message de début de test
echo "Starting network connectivity test..."

# Liste des serveurs à tester
SERVERS=("google.com" "github.com" "example.com")

# Boucle de ping pour chaque serveur
for SERVER in "${SERVERS[@]}"; do
    echo "Pinging $SERVER..."
    ping -c 4 "$SERVER"  # Ping avec 4 requêtes
    if [ $? -eq 0 ]; then
        echo "$SERVER is reachable."
    else
        echo "$SERVER is not reachable."
    fi
done
# Affichage du résultat du ping
# Fin de la vérification de la connectivité

# Test de vitesse réseau avec iperf
# Vérification si iperf est installé
if ! command -v iperf &> /dev/null; then
    echo "iperf is not installed. Please install it to run the speed test."
    exit 1
fi
# Lancement du test de vitesse avec iperf
echo "Starting iperf speed test..."
iperf -c iperf.he.net -t 10  # Test de 10 secondes vers le serveur iperf de Hurricane Electric
if [ $? -eq 0 ]; then
    echo "iperf speed test completed successfully."
else
    echo "iperf speed test failed."
fi
# Fin du test de vitesse réseau

# Lancement du client iperf vers un serveur prédéfini
# Vérification des ports ouverts via nc (netcat)
# Vérification si nc est installé
if ! command -v nc &> /dev/null; then
    echo "nc (netcat) is not installed. Please install it to check open ports."
    exit 1
fi

# Liste des hôtes et ports à vérifier
HOSTS_PORTS=("localhost:22" "localhost:80" "localhost:443")
# Boucle de vérification des ports
for HOST_PORT in "${HOSTS_PORTS[@]}"; do
    HOST=$(echo "$HOST_PORT" | cut -d':' -f1)
    PORT=$(echo "$HOST_PORT" | cut -d':' -f2)
    echo "Checking port $PORT on $HOST..."
    nc -zv "$HOST" "$PORT"  # Vérification du port
    if [ $? -eq 0 ]; then
        echo "Port $PORT on $HOST is open."
    else
        echo "Port $PORT on $HOST is closed or unreachable."
    fi
done
# Affichage du résultat de la vérification des ports
# Fin de la vérification des ports

# Boucle de test de port avec nc
# Liste des ports à tester
PORTS=(22 80 443)
for PORT in "${PORTS[@]}"; do
    echo "Testing port $PORT..."
    nc -zv localhost "$PORT"  # Test de la connectivité du port
    if [ $? -eq 0 ]; then
        echo "Port $PORT is open."
    else
        echo "Port $PORT is closed or unreachable."
    fi
done
# Fin du script de test réseau

# Affichage du statut (ouvert/fermé)
# Résumé des tests effectués
# Journalisation des résultats dans un fichier
# Journalisation des résultats dans un fichier
LOG_FILE="network_test_results.log"
{
    echo "Network Test Results - $(date)"
    echo "---------------------------------"
    echo "Ping Results:"
    for SERVER in "${SERVERS[@]}"; do
        ping -c 1 "$SERVER" | grep 'bytes from'
    done
    echo ""

    echo "iperf Speed Test Results:"
    iperf -c iperf.he.net -t 10

    echo ""

    echo "Port Check Results:"
    for HOST_PORT in "${HOSTS_PORTS[@]}"; do
        HOST=$(echo "$HOST_PORT" | cut -d':' -f1)
        PORT=$(echo "$HOST_PORT" | cut -d':' -f2)
        nc -zv "$HOST" "$PORT" 2>&1 | grep 'succeeded\|failed'
    done

} > "$LOG_FILE"
echo "Network test results have been logged to $LOG_FILE."
# Fin du script de test réseau

# Affichage d'un message de fin
echo "Network testing completed. Check the log file for details."
# Fin du script de test réseau
