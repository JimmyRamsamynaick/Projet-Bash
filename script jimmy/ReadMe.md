# 🔧 Outils d’Administration Système Linux

Ce dépôt contient une suite de scripts Bash destinés à automatiser des tâches courantes d'administration système. Chaque script est conçu pour être simple, modulaire et facilement adaptable à vos besoins spécifiques.

## 📁 Contenu du dépôt

- [`test_reseaux.sh`](./test_reseaux.sh) — Test de connectivité réseau local et Internet.
- [`synch_repertoire.sh`](./synch_repertoire.sh) — Synchronisation de répertoires avec `rsync`.
- [`rapport_sys.sh`](./rapport_sys.sh) — Génération d’un rapport système complet.
- [`analyse_log.sh`](./analyse_log.sh) — Analyse des logs systèmes pour détecter des erreurs ou activités suspectes.

---

## 📡 `test_reseaux.sh` – Test de connectivité réseau

### Fonctionnalité
Ce script teste la connectivité réseau vers différentes cibles :
- Adresse IP d’un routeur local (ex: `192.168.1.1`)
- Un site Internet (ex: `google.com`)
- Résolution DNS

### Utilisation

```bash
bash test_reseaux.sh

Exemple de sortie

Test de connectivité vers 192.168.1.1 : OK
Test de connectivité vers google.com : OK
Résolution DNS : OK

🔄 synch_repertoire.sh – Synchronisation de répertoires
Fonctionnalité

Script de synchronisation de répertoires locaux vers une destination (locale ou distante) à l'aide de rsync.
Utilisation

bash synch_repertoire.sh <source> <destination>

Exemple :

bash synch_repertoire.sh /home/user/Documents /mnt/backup/Documents

Le script :

    Vérifie que les deux arguments sont bien fournis

    Synchronise les données en préservant les permissions, dates, liens symboliques, etc.

    Affiche les fichiers copiés/supprimés

🖥️ rapport_sys.sh – Rapport d’état système
Fonctionnalité

Ce script génère un rapport sur l’état de la machine incluant :

    Informations système (OS, noyau, uptime)

    Utilisation CPU / RAM / disque

    Utilisateurs connectés

    Processus les plus consommateurs

    Interfaces réseau et adresses IP

Utilisation

bash rapport_sys.sh

Exemple de sortie

--- Rapport Système ---
Nom d’hôte      : machine001
OS              : Ubuntu 22.04
Uptime          : 2 days, 3 hours
Utilisation CPU : 15%
Mémoire utilisée: 2.1G / 8G
Espace disque   : 40G libres sur /dev/sda1
...

🔍 analyse_log.sh – Analyse de logs système
Fonctionnalité

Le script analyse les fichiers de logs système (/var/log/syslog ou /var/log/messages) pour :

    Rechercher les erreurs (error, fail, denied, etc.)

    Identifier les connexions SSH suspectes ou échouées

    Afficher les logs récents filtrés

Utilisation

bash analyse_log.sh

Le script détecte automatiquement le fichier de log en fonction de la distribution.
Exemple de sortie

[ERREURS]
Jun 26 12:03:45 sshd[1234]: Failed password for invalid user root from 192.168.1.20 port 2222 ssh2
...

[STATISTIQUES]
Échecs SSH : 12 tentatives
Nombre total d’erreurs : 34
...

✅ Pré-requis

Ces scripts nécessitent les outils suivants (généralement présents sur la majorité des distributions Linux) :

    bash

    ping, host

    rsync

    free, df, top, uptime, ip ou ifconfig

    Accès en lecture à /var/log/

⚠️ Avertissements

    Certains scripts doivent être exécutés avec les droits sudo pour accéder à toutes les informations (notamment analyse_log.sh).

    Assurez-vous de tester les scripts dans un environnement de test avant de les utiliser en production.

    Les scripts sont fournis "tels quels" sans garantie.

📜 Licence

Ce projet est sous licence MIT. Vous êtes libre de l'utiliser, le modifier et le distribuer.