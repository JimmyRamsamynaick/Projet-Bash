# 🛠️ Panel d'Outils Bash Professionnels

Ce dépôt regroupe une suite de scripts shell conçus pour automatiser et simplifier des tâches systèmes courantes dans un environnement professionnel.  
Ces scripts sont organisés par contributeurs et thématiques, afin de garantir modularité, lisibilité et efficacité.

---

## 📁 Structure du dépôt

sameer/ \
├── README.md # Documentation du projet \
├── analysSSH.sh # Analyse des connexions SSH \
├── cleanFiles.sh # Nettoyage automatique de fichiers temporaires/inutiles \
├── majPackages.sh # Mise à jour automatisée des paquets système \
├── templateGenerator.sh # Génération de templates de scripts Bash \
│
├── script alex/ \
│ ├── disque.sh # Vérification et rapport de l'espace disque \
│ ├── optimisation.sh # Optimisations système simples \
│ ├── planificateur.sh # Planification de tâches récurrentes (crons) \
│ └── sauvegarde.sh # Script de sauvegarde automatique \
│
└── script jimmy/ \
├── analyse_log.sh # Analyse automatisée de fichiers de logs \
├── rapport_sys.sh # Génération de rapports système \
├── synch_repertoire.sh # Synchronisation de répertoires distants \
└── test_reseaux.sh # Outils de test réseau de base \


---

## ✅ Objectifs

- Fournir un **ensemble de scripts utiles**, prêts à être utilisés en environnement serveur Linux/Unix.
- **Automatiser les tâches d’administration système**.
- Servir de **base pédagogique** pour les personnes apprenant le scripting Bash.

---

## 🚀 Utilisation

1. **Cloner le dépôt :**

```bash
git clone git@github.com:JimmyRamsamynaick/Projet-Bash.git

    Donner les droits d'exécution aux scripts si nécessaire :

chmod +x *.sh script\ alex/*.sh script\ jimmy/*.sh

    Exécuter un script :

./cleanFiles.sh

    💡 Tous les scripts sont commentés et conçus pour afficher des logs clairs en sortie.

🧑‍💼 Contributeurs

    Sameer : outils système généraux et gestion de templates

    Alex : scripts orientés maintenance et planification

    Jimmy : scripts orientés surveillance, synchronisation et diagnostic réseau \
📄 Licence

Ce projet est sous licence MIT — voir le fichier LICENSE pour plus d’informations.