# 🛠️ Panel d'Outils Bash Professionnels

Ce dépôt regroupe une suite de scripts shell conçus pour automatiser et simplifier des tâches systèmes courantes dans un environnement professionnel.  
Les scripts sont organisés par contributeurs et thématiques afin de garantir modularité, lisibilité et efficacité.

---

## 📁 Structure du dépôt

Projet-Bash/ \
├── dossier arbo/ \
├── sameer/ \
│ ├── analysSSH.sh # Analyse des connexions SSH \
│ ├── cleanFiles.sh # Nettoyage automatique de fichiers temporaires/inutiles \
│ ├── majPackages.sh # Mise à jour automatisée des paquets système \
│ └── templateGenerator.sh # Génération de templates de scripts Bash \
│ \
├── script alex/ \
│ ├── disque.sh # Vérification et rapport de l'espace disque \
│ ├── optimisation.sh # Optimisations système simples \
│ ├── planificateur.sh # Planification de tâches récurrentes (crons) \
│ └── sauvegarde.sh # Script de sauvegarde automatique \
│ \
├── script jimmy/ \
│ ├── analyse_log.sh # Analyse automatisée de fichiers de logs \
│ ├── rapport_sys.sh # Génération de rapports système \
│ ├── synch_repertoire.sh # Synchronisation de répertoires distants \
│ └── test_reseaux.sh # Outils de test réseau de base \
│ \
├── menu.sh # Menu principal d’accès aux différents scripts \
└── ReadMe.md # Présentation du projet \


---

## ✅ Objectifs

- Fournir un **ensemble de scripts prêts à l’emploi** pour la gestion système.
- **Automatiser les tâches courantes** d’un administrateur ou technicien Linux.
- Servir de **base pédagogique** pour apprendre le scripting Bash.

---

## 🚀 Utilisation

### 1. Cloner le dépôt :

```bash
git clone git@github.com:JimmyRamsamynaick/Projet-Bash.git
cd Projet-Bash

2. Donner les droits d'exécution :

chmod +x sameer/*.sh script\ alex/*.sh script\ jimmy/*.sh menu.sh

3. Lancer un script :

./sameer/cleanFiles.sh

💡 Tous les scripts sont commentés, interactifs et conçus pour afficher des logs clairs en sortie.
👥 Contributeurs

    Sameer : outils système généraux, gestion de paquets et génération de templates

    Alex : scripts de maintenance, planification et sauvegarde

    Jimmy : scripts de surveillance, journalisation et tests réseau

📄 Licence

Ce projet est sous licence MIT — voir le fichier LICENSE pour plus d’informations.