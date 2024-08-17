#!/bin/bash

# Fonction pour afficher la bannière
show_banner() {
    clear
    gum style \
        --foreground 212 \
        --border-foreground 212 \
        --align center \
        --width 40 \
        --margin "1 2" \
        "Oh-My-Termux"
}

# Vérification et installation de gum
if ! command -v gum &> /dev/null; then
    echo "gum n'est pas installé. Installation en cours..."
    pkg update -y && pkg install gum -y
fi

# Vérification de l'exécution de termux-setup-storage
if [ ! -d "$HOME/storage" ]; then
    echo "Exécution de termux-setup-storage..."
    termux-setup-storage
fi

# Afficher la bannière
show_banner

# Fonction pour lister les liens symboliques existants
list_symlinks() {
    symlinks=()
    for item in "$HOME"/*; do
        if [ -L "$item" ]; then
            symlinks+=("$(basename "$item")")
        fi
    done
}

# Mode suppression
if [[ "$1" == "--delete" || "$1" == "-d" ]]; then
    list_symlinks
    if [ ${#symlinks[@]} -eq 0 ]; then
        echo "Aucun lien symbolique à supprimer."
        exit 0
    fi
    symlinks+=("Tous les répertoires")  # Ajouter l'option "Tous les répertoires"
    symlinks_to_delete=$(printf "%s\n" "${symlinks[@]}" | gum choose --no-limit --header="Sélectionner avec Espace les liens symboliques à supprimer :")
    echo ""
    if [[ " ${symlinks_to_delete[*]} " == *"Tous les répertoires"* ]]; then
        symlinks_to_delete=("${symlinks[@]}")
        # Retirer "Tous les répertoires" pour éviter une erreur
        symlinks_to_delete=("${symlinks_to_delete[@]/Tous les répertoires}")
    fi
    for link in "${symlinks_to_delete[@]}"; do
        if [ -n "$link" ] && [ -L "$HOME/$link" ]; then
            rm "$HOME/$link"
        elif [ -n "$link" ]; then
            echo "$link n'est pas un lien symbolique, vérifiez le type avant de supprimer."
        fi
    done
    gum style --foreground 212 --bold "Liens symboliques supprimés avec succès !"
    echo ""
    exit 0
fi

# Liste des répertoires possibles
directories=("📂 Téléchargement" "🖼️ Images" "📸 Photos" "🎥 Vidéos" "🎵 Musique" "📄 Documents" "📁 Stockage Interne" "Tous les répertoires")

# Exclusion des liens symboliques déjà existants
list_symlinks
filtered_directories=()
for dir in "${directories[@]}"; do
    if [[ ! " ${symlinks[@]} " =~ " ${dir} " ]]; then
        filtered_directories+=("$dir")
    fi
done

# Utilisation de gum pour sélectionner les répertoires
selected_dirs=$(printf "%s\n" "${filtered_directories[@]}" | gum choose --no-limit --height=10 --header="Sélectionner avec espace les liens symboliques à créer :")
echo ""

# Vérification de la sélection "Tous les répertoires"
if [[ " ${selected_dirs[*]} " == *"Tous les répertoires"* ]]; then
    selected_dirs=("📂 Téléchargement" "🖼️ Images" "📸 Photos" "🎥 Vidéos" "🎵 Musique" "📄 Documents" "📁 Stockage Interne")
fi

# Création des répertoires utilisateur
for dir in "${selected_dirs[@]}"; do
    case $dir in
        "📂 Téléchargement")
            if [ ! -L "$HOME/📂 Téléchargement" ]; then
                ln -s "$HOME/storage/downloads" "$HOME/📂 Téléchargement"
            else
                echo "Le lien symbolique pour 📂 Téléchargement existe déjà."
            fi
            ;;
        "🖼️ Images")
            if [ ! -L "$HOME/🖼️ Images" ]; then
                ln -s "$HOME/storage/pictures" "$HOME/🖼️ Images"
            else
                echo "Le lien symbolique pour 🖼️ Images existe déjà."
            fi
            ;;
        "📸 Photos")
            if [ ! -L "$HOME/📸 Photos" ]; then
                ln -s "$HOME/storage/dcim" "$HOME/📸 Photos"
            else
                echo "Le lien symbolique pour 📸 Photos existe déjà."
            fi
            ;;
        "🎥 Vidéos")
            if [ ! -L "$HOME/🎥 Vidéos" ]; then
                ln -s "$HOME/storage/movies" "$HOME/🎥 Vidéos"
            else
                echo "Le lien symbolique pour 🎥 Vidéos existe déjà."
            fi
            ;;
        "🎵 Musique")
            if [ ! -L "$HOME/🎵 Musique" ]; then
                ln -s "$HOME/storage/music" "$HOME/🎵 Musique"
            else
                echo "Le lien symbolique pour 🎵 Musique existe déjà."
            fi
            ;;
        "📄 Documents")
            if [ ! -L "$HOME/📄 Documents" ]; then
                ln -s "$HOME/storage/documents" "$HOME/📄 Documents"
            else
                echo "Le lien symbolique pour 📄 Documents existe déjà."
            fi
            ;;
        "📁 Stockage Interne")
            if [ ! -L "$HOME/📁 Stockage Interne" ]; then
                ln -s "$HOME/storage/shared" "$HOME/📁 Stockage Interne"
            else
                echo "Le lien symbolique pour 📁 Stockage Interne existe déjà."
            fi
            ;;
    esac
done

if [ ${#selected_dirs[@]} -gt 0 ]; then
    gum style --foreground 212 --bold "Liens symboliques créés avec succès !"
    echo ""
else
    echo "Aucun lien symbolique n'a été créé."
    echo ""
fi
