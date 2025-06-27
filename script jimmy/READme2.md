# 🔧 Scripts d'Administration Système Linux

![Version](https://img.shields.io/badge/version-1.29-blue.svg)
![Scripts](https://img.shields.io/badge/scripts-4-green.svg)
![License](https://img.shields.io/badge/license-MIT-yellow.svg)
![Bash](https://img.shields.io/badge/bash-4.0%2B-orange.svg)

Ce dépôt contient une suite complète de scripts Bash destinés à automatiser des tâches courantes d'administration système Linux. Chaque script est conçu pour être robuste, modulaire et facilement adaptable à vos besoins spécifiques.

## 📊 Vue d'ensemble

| 📈 Statistiques | Valeur |
|------------------|---------|
| **Version actuelle** | 1.29 |
| **Nombre de scripts** | 4 |
| **Lignes de code total** | ~400 |
| **Auteurs** | Jimmy RAMSAMYNAÏCK, Sameer VALI ADAM, Alexandre BADOUARD |

---

## 📁 Contenu du dépôt

<details>
<summary>📡 <strong>test_reseaux.sh</strong> - Test de connectivité réseau</summary>

### Fonctionnalités
- ✅ Test de connectivité via ping vers multiples serveurs
- ⚡ Test de vitesse réseau avec iperf
- 🔍 Vérification de ports ouverts via netcat
- 📝 Journalisation automatique des résultats

### Serveurs testés par défaut
- `google.com`
- `github.com` 
- `example.com`

### Ports vérifiés
- **22** (SSH)
- **80** (HTTP)
- **443** (HTTPS)

</details>

<details>
<summary>🔄 <strong>synch_repertoire.sh</strong> - Synchronisation de répertoires</summary>

### Fonctionnalités
- 🚀 Synchronisation avec rsync (préservation des métadonnées)
- ⏱️ Mode temps réel avec inotify
- 🔄 Mode intervalle pour exécution planifiée
- 🧪 Mode test intégré automatique
- 🔐 Vérification des droits administrateur

### Modes disponibles
| Mode | Description |
|------|-------------|
| `intervalle` | Synchronisation unique |
| `temps réel` | Surveillance continue (60s) |

</details>

<details>
<summary>📊 <strong>rapport_sys.sh</strong> - Génération de rapport système</summary>

### Informations collectées
- 🖥️ Informations système (OS, version, architecture)
- 💾 Utilisation CPU et mémoire
- 💿 Espace disque disponible
- 🔧 Services actifs
- 🌐 Configuration réseau
- 👥 Utilisateurs et processus

### Formats de sortie
- 📄 Rapport texte
- 📑 Conversion PDF automatique (si pandoc disponible)

</details>

<details>
<summary>🔍 <strong>analyse_log.sh</strong> - Analyse des logs Apache</summary>

### Analyses effectuées
- ❌ Détection d'erreurs HTTP (4xx/5xx)
- 🚨 Identification d'IP suspectes (>100 requêtes)
- 📈 Statistiques d'accès générales
- 📋 Rapport détaillé avec métriques

### Fichiers analysés
- `/var/log/apache2/access.log`
- `/var/log/apache2/error.log`

</details>

---

## 🚀 Installation et utilisation

### Pré-requis système

| Composant | Statut | Description |
|-----------|--------|-------------|
| **Bash** | ✅ Requis | Version 4.0+ |
| **rsync** | ⚠️ Optionnel | Pour synchronisation |
| **inotify-tools** | ⚠️ Optionnel | Pour mode temps réel |
| **iperf** | ⚠️ Optionnel | Pour tests de vitesse |
| **netcat** | ⚠️ Optionnel | Pour tests de ports |
| **pandoc** | ⚠️ Optionnel | Pour génération PDF |

### Installation des dépendances
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y rsync inotify-tools iperf netcat-openbsd pandoc texlive-latex-recommended

# CentOS/RHEL
sudo yum install -y rsync inotify-tools iperf nc pandoc texlive
```

### Utilisation des scripts

#### 📡 Test de connectivité réseau
```bash
sudo ./test_reseaux.sh
```
**Sortie attendue :**
```
Starting network connectivity test...
Pinging google.com...
google.com is reachable.
iperf speed test completed successfully.
Port 22 on localhost is open.
Network test results have been logged to network_test_results.log.
```

#### 🔄 Synchronisation de répertoires
```bash
# Mode test automatique
sudo ./synch_repertoire.sh

# Mode manuel
sudo ./synch_repertoire.sh --source /path/source --destination /path/dest --mode intervalle
```

#### 📊 Génération de rapport système
```bash
sudo ./rapport_sys.sh
```
**Fichiers générés :**
- `/tmp/rapports/rapport_systeme_YYYYMMDD_HHMMSS.txt`
- `/tmp/rapports/rapport_systeme_YYYYMMDD_HHMMSS.pdf`

#### 🔍 Analyse des logs Apache
```bash
sudo ./analyse_log.sh
```
**Rapports générés :**
- `/tmp/log_analysis_apache_report.txt`
- `/tmp/apache_suspicious_ips.txt`
- `/tmp/apache_frequent_errors.txt`

---

## 🛠️ Configuration avancée

### Variables d'environnement

| Variable | Script | Description | Défaut |
|----------|--------|-------------|---------|
| `SERVERS` | test_reseaux.sh | Liste des serveurs à tester | google.com, github.com, example.com |
| `PORTS` | test_reseaux.sh | Ports à vérifier | 22, 80, 443 |
| `LOG_FILES` | analyse_log.sh | Fichiers de logs Apache | /var/log/apache2/*.log |

### Personnalisation des seuils

```bash
# analyse_log.sh - Modifier le seuil d'IP suspectes
awk '$1 > 50'  # Au lieu de 100 requêtes

# synch_repertoire.sh - Modifier le timeout temps réel  
inotifywait -r -e create,modify,delete "$source" -q -t 120  # 120 secondes
```

---

## 📈 Métriques et performances

### Temps d'exécution moyens

| Script | Durée moyenne | Facteurs d'influence |
|--------|---------------|---------------------|
| `test_reseaux.sh` | 30-60s | Latence réseau, timeout iperf |
| `synch_repertoire.sh` | Variable | Taille des données, vitesse I/O |
| `rapport_sys.sh` | 10-30s | Nombre de services, conversion PDF |
| `analyse_log.sh` | 15-120s | Taille des logs Apache |

### Ressources utilisées

- **CPU** : Faible utilisation (< 10%)
- **RAM** : 10-50 MB selon le script
- **I/O** : Modéré pour synchronisation et analyse logs

---

## ⚠️ Sécurité et bonnes pratiques

### Permissions requises

| Script | Permissions | Justification |
|--------|-------------|---------------|
| `test_reseaux.sh` | sudo | Accès privilégié aux outils réseau |
| `synch_repertoire.sh` | sudo | Modification de fichiers système |
| `rapport_sys.sh` | sudo | Lecture informations système |
| `analyse_log.sh` | sudo | Accès aux logs Apache |

### Recommandations sécurité

- 🔒 **Validation** : Testez en environnement de développement
- 📝 **Logs** : Surveillez les fichiers de journalisation
- 🔍 **Audit** : Vérifiez les rapports générés
- 🚫 **Limitation** : Exécutez avec privilèges minimaux nécessaires

---

## 🐛 Dépannage

<details>
<summary><strong>Erreurs courantes et solutions</strong></summary>

### `ping: command not found`
```bash
sudo apt install iputils-ping  # Ubuntu/Debian
sudo yum install iputils        # CentOS/RHEL
```

### `rsync: command not found`
```bash
sudo apt install rsync         # Ubuntu/Debian
sudo yum install rsync         # CentOS/RHEL
```

### `Permission denied` sur les logs
```bash
# Vérifier les permissions
ls -la /var/log/apache2/
# Exécuter avec sudo si nécessaire
sudo ./analyse_log.sh
```

### Conversion PDF échoue
```bash
# Installer les dépendances LaTeX complètes
sudo apt install texlive-full  # Solution complète mais lourde
```

</details>

---

## 📝 Changelog

### Version 1.29 (Actuelle)
- ✨ Ajout du mode test automatique pour `synch_repertoire.sh`
- 🐛 Correction de la gestion d'erreurs dans `analyse_log.sh`
- 📊 Amélioration des rapports avec métriques détaillées
- 🔧 Optimisation des performances pour gros volumes de logs

### Version 1.28
- 🔄 Refactorisation du système de journalisation
- 🛡️ Renforcement des vérifications de sécurité

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. 🍴 Fork le projet
2. 🌿 Créez une branche feature (`git checkout -b feature/AmazingFeature`)
3. 💾 Committez vos changements (`git commit -m 'Add some AmazingFeature'`)
4. 📤 Push vers la branche (`git push origin feature/AmazingFeature`)
5. 🔄 Ouvrez une Pull Request

---

## 👥 Auteurs

- **Jimmy RAMSAMYNAÏCK** - *Développeur principal*
- **Sameer VALI ADAM** - *Développeur*  
- **Alexandre BADOUARD** - *Développeur*

---

## 📜 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

## 🔗 Liens utiles

- 📚 [Documentation Bash](https://www.gnu.org/software/bash/manual/)
- 🔧 [Guide rsync](https://rsync.samba.org/documentation.html)
- 📊 [Manuel Apache](https://httpd.apache.org/docs/)
- 🐧 [Administration Linux](https://tldp.org/guides.html)

---

<div align="center">

**⭐ Si ce projet vous est utile, n'hésitez pas à lui donner une étoile !**

![Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)
![Love](https://img.shields.io/badge/Made%20with-❤️-red.svg)

</div>
