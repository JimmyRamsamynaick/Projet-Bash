# 🛠️ Scripts Fouarlic Industry - Administration et Sécurité

<div align="center">

![Version](https://img.shields.io/badge/Version-1.29-blue?style=for-the-badge)
![Scripts](https://img.shields.io/badge/Scripts-4-green?style=for-the-badge)
![Bash](https://img.shields.io/badge/Bash-5.0+-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-red?style=for-the-badge)

**Collection de scripts Bash utilitaires pour l'administration système et la sécurité**

[🚀 Installation](#-installation-et-utilisation) • [📖 Documentation](#-scripts-disponibles) • [🔧 Configuration](#-configuration) • [📋 Tests](#-tests-et-validation)

</div>

---

## 📊 Vue d'ensemble

<details>
<summary>📈 <strong>Statistiques du projet</strong> (cliquez pour développer)</summary>

| Métrique | Valeur |
|----------|--------|
| 🔢 **Nombre de scripts** | 4 |
| 📦 **Version actuelle** | 1.29 |
| 🛡️ **Scripts sécurité** | 2 |
| ⚙️ **Scripts administration** | 2 |
| 📅 **Dernière mise à jour** | 27/06/2025 |

</details>

<details>
<summary>🎯 <strong>Fonctionnalités principales</strong> (cliquez pour développer)</summary>

- ✅ **Analyse des connexions SSH** avec détection d'anomalies
- 🔒 **Détection et sécurisation** de fichiers sensibles
- 📦 **Surveillance automatique** des mises à jour système
- 🏗️ **Génération rapide** de templates de projet
- 📊 **Rapports détaillés** avec horodatage
- 🤖 **Automatisation** via cron jobs

</details>

---

## 🔧 Scripts disponibles

### 1. 🔍 `analysSSH.sh` - Analyseur de connexions SSH
<div align="center">

![SSH](https://img.shields.io/badge/Type-Sécurité-red?style=flat-square)
![Output](https://img.shields.io/badge/Output-Rapport-blue?style=flat-square)

</div>

<details>
<summary><strong>📋 Fonctionnalités détaillées</strong></summary>

| Fonction | Description | Sortie |
|----------|-------------|--------|
| 🔐 **Connexions réussies** | Liste toutes les authentifications SSH valides | Date, utilisateur, IP |
| 👥 **Utilisateurs actifs** | Identifie les comptes connectés | Liste unique |
| 🌐 **Adresses IP** | Répertorie les sources de connexion | IPs triées |
| ⏰ **Heures suspectes** | Détecte les connexions 0h-5h | Alertes horodatées |

</details>

<details>
<summary><strong>🧪 Jeu d'essai</strong></summary>

Créer le fichier de test :
```bash
nano faux_auth.log
```

Contenu d'exemple :
```log
Jun 26 02:45:17 sameer sshd[12345]: Accepted password for root from 192.168.0.5 port 54321 ssh2
Jun 26 14:12:00 sameer sshd[12346]: Accepted password for sameer from 8.8.8.8 port 54422 ssh2
Jun 26 03:10:55 sameer sshd[12347]: Accepted publickey for admin from 185.60.216.35 port 65535 ssh2
Jun 26 09:22:10 sameer sshd[12348]: Failed password for invalid user test from 190.100.50.12 port 60000 ssh2
```

</details>

---

### 2. 🔒 `cleanFiles.sh` - Nettoyeur de fichiers sensibles
<div align="center">

![Security](https://img.shields.io/badge/Type-Sécurité-red?style=flat-square)
![Interactive](https://img.shields.io/badge/Mode-Interactif-green?style=flat-square)

</div>

<details>
<summary><strong>🎯 Types de fichiers détectés</strong></summary>

| Catégorie | Extensions/Noms | Contenu analysé |
|-----------|-----------------|-----------------|
| 🔑 **Clés privées** | `id_rsa`, `*.pem`, `*.key` | Fichiers de clés |
| ⚙️ **Configuration** | `.env`, `*secret*` | Variables d'environnement |
| 🔐 **Authentification** | `*password*` | Mots de passe |
| 📄 **Fichiers texte** | `*.log`, `*.txt`, `*.conf` | Mots-clés sensibles |

</details>

<details>
<summary><strong>🧪 Test du script</strong></summary>

Créer des fichiers de test :
```bash
# Fichier avec nom sensible
touch mon_password_file.txt

# Fichier avec contenu sensible
echo "secret_key=123456" > test_secret.conf
echo "password=admin123" > config.txt

# Fichier de clé simulé
touch fake_id_rsa
```

</details>

---

### 3. 📦 `majPackages.sh` - Surveillance des mises à jour
<div align="center">

![System](https://img.shields.io/badge/Type-Administration-blue?style=flat-square)
![APT](https://img.shields.io/badge/APT-Compatible-orange?style=flat-square)

</div>

<details>
<summary><strong>⚙️ Configuration automatique</strong></summary>

| Paramètre | Valeur | Description |
|-----------|--------|-------------|
| 📅 **Fréquence** | Hebdomadaire (Lundi) | Tous les lundis à 9h |
| 📁 **Sortie** | `/home/$USER/` | Répertoire de sauvegarde |
| 📊 **Format** | `maj_packages_YYYY-MM-DD_HH-MM-SS.txt` | Nommage automatique |

**Tâche cron suggérée :**
```bash
0 9 * * 1 sudo /home/sameer/Projet-Bash/sameer/majPackages.sh >> /home/$USER/logs_maj.txt 2>&1
```

</details>

---

### 4. 🏗️ `templateGenerator.sh` - Générateur de templates
<div align="center">

![Development](https://img.shields.io/badge/Type-Développement-purple?style=flat-square)
![Templates](https://img.shields.io/badge/Templates-2-yellow?style=flat-square)

</div>

<details>
<summary><strong>📁 Structures générées</strong></summary>

#### 🌐 **Projet HTML**
```
nom_projet/
├── 📄 index.html          # Template HTML5 complet
├── 📁 css/
│   └── 🎨 style.css       # Fichier CSS vide
├── 📁 js/
│   └── ⚡ script.js       # Fichier JavaScript vide
└── 📖 README.md           # Documentation auto-générée
```

#### ⚡ **Projet Bash**
```
nom_projet/
├── 📁 scripts/
│   └── 🔧 main.sh         # Script principal exécutable
├── 📁 docs/               # Dossier documentation
└── 📖 README.md           # Documentation auto-générée
```

</details>

---

## 🚀 Installation et utilisation

<details>
<summary><strong>📋 Prérequis système</strong></summary>

| Composant | Version minimale | Obligatoire |
|-----------|------------------|-------------|
| 🐧 **Linux/Unix** | Toute distribution | ✅ |
| 🔧 **Bash** | 4.0+ | ✅ |
| 🛡️ **Sudo** | Pour `majPackages.sh` | ⚠️ |
| 📊 **APT** | Pour gestion paquets | ⚠️ |

</details>

<details>
<summary><strong>⚡ Installation rapide</strong></summary>

```bash
# Cloner le dépôt
git clone <repository>
cd fouarlic-scripts

# Rendre les scripts exécutables
chmod +x *.sh

# Vérifier l'installation
ls -la *.sh
```

</details>

<details>
<summary><strong>🎮 Guide d'utilisation</strong></summary>

| Script | Commande | Type d'exécution |
|--------|----------|------------------|
| 🔍 **SSH Analyzer** | `./analysSSH.sh` | Ponctuelle |
| 🔒 **File Cleaner** | `./cleanFiles.sh` | Interactive |
| 📦 **Package Monitor** | `./majPackages.sh` | Automatique |
| 🏗️ **Template Generator** | `./templateGenerator.sh` | Interactive |

</details>

---

## 🔧 Configuration

<details>
<summary><strong>⚙️ Variables d'environnement</strong></summary>

### `analysSSH.sh`
```bash
HEURE_SUSPECTE_DEBUT=0    # Début période suspecte
HEURE_SUSPECTE_FIN=5      # Fin période suspecte
LOG="./faux_auth.log"     # Fichier de logs à analyser
```

### `cleanFiles.sh`
```bash
SECURE_DIR="$HOME/fichiers_sensibles"    # Dossier de quarantaine
```

</details>

---

## 📋 Tests et validation

<details>
<summary><strong>✅ Checklist de validation</strong></summary>

- [ ] **analysSSH.sh** : Fichier `faux_auth.log` créé avec données de test
- [ ] **cleanFiles.sh** : Fichiers sensibles créés pour test
- [ ] **majPackages.sh** : Droits sudo configurés
- [ ] **templateGenerator.sh** : Permissions d'écriture dans le répertoire courant
- [ ] **Cron jobs** : Tâches programmées configurées (optionnel)

</details>

<details>
<summary><strong>🐛 Résolution de problèmes courants</strong></summary>

| Problème | Solution |
|----------|----------|
| ❌ **Permission denied** | `chmod +x script.sh` |
| ❌ **Fichier log introuvable** | Créer le jeu d'essai |
| ❌ **Sudo requis** | Exécuter avec `sudo` |
| ❌ **Dossier inexistant** | Le script crée automatiquement |

</details>

---

<div align="center">

## 🤝 Contribution

![Made with](https://img.shields.io/badge/Made%20with-❤️-red?style=flat-square)
![Bash](https://img.shields.io/badge/Bash-Script-green?style=flat-square)

**Développé par Fouarlic Industry**

[🐛 Signaler un bug](https://theuselessweb.com/) • [💡 Proposer une amélioration](https://theuselessweb.com/) • [📧 Contact](mailto:contact@fouarlic.com)

---

⭐ **N'hésitez pas à donner une étoile si ces scripts vous sont utiles !** ⭐

</div>
