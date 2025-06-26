#!/bin/bash
# Fonction : Créer des templates de projet
# Auteur : Abdoul Sameer VALI ADAM

# === Fonction de création d’un projet HTML simple ===
creer_projet_html() {
    read -p "Nom du projet HTML : " nom_projet
    mkdir -p "$nom_projet/css" "$nom_projet/js"

    cat > "$nom_projet/index.html" <<EOF
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$nom_projet</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h1>Bienvenue sur le projet $nom_projet</h1>
    <script src="js/script.js"></script>
</body>
</html>
EOF

    touch "$nom_projet/css/style.css"
    touch "$nom_projet/js/script.js"
    echo "# $nom_projet" > "$nom_projet/README.md"

    echo "Projet HTML '$nom_projet' créé avec succès !"
    ls -R "$nom_projet"
}

# === Fonction de création d’un projet Bash simple ===
creer_projet_bash() {
    read -p "Nom du projet Bash : " nom_projet
    mkdir -p "$nom_projet/scripts" "$nom_projet/docs"

    cat > "$nom_projet/scripts/main.sh" <<EOF
#!/bin/bash
# Script principal du projet $nom_projet
# Auteur : $USER

echo "Bienvenue dans le projet $nom_projet"
EOF

    chmod +x "$nom_projet/scripts/main.sh"
    echo "# $nom_projet" > "$nom_projet/README.md"

    echo "Projet Bash '$nom_projet' créé avec succès !"
    ls -R "$nom_projet"
}

# === Menu principal ===
while true; do
    echo "=== Générateur de projet ==="
    echo "1) Projet Site HTML"
    echo "2) Projet Bash"
    echo "3) Quitter"
    read -p "Choix : " choix

    case $choix in
        1) creer_projet_html ;;
        2) creer_projet_bash ;;
        3) echo "À bientôt !"; exit 0 ;;
        *) echo "Choix invalide." ;;
    esac
done
