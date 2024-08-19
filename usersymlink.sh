#!/bin/bash

# Mise à jour des paquets Termux...
echo "Mise à jour des paquets Termux..."
clear && pkg update -y

# Variable pour déterminer si gum doit être utilisé
USE_GUM=false

# Vérification des arguments
for arg in "$@"; do
    case $arg in
        --gum|-g)
            USE_GUM=true
            shift
            ;;
    esac
done

# Fonction pour vérifier et installer gum
check_and_install_gum() {
    if $USE_GUM && ! command -v gum &> /dev/null; then
        echo "gum n'est pas installé. Installation en cours..."
        pkg install gum -y
    fi
}

# Fonction pour afficher la bannière
show_banner() {
    clear
    if $USE_GUM; then
        gum style \
            --foreground 212 \
            --border-foreground 212 \
            --border double \
            --align center \
            --width 40 \
            --margin "1 2" \
            --padding "1 1" \
            "Oh-My-Termux" \
            "User Symlink" \
            ""
    else
        echo -e "\e[1;34mOh-My-Termux\e[0m"
        echo -e "\e[1;35mUser Symlink\e[0m"
        echo
    fi
}

# Fonction pour afficher un message d'erreur
display_error_message() {
    clear
    show_banner
    echo -e "\e[1;31mErreur de saisie. Veuillez recommencer.\e[0m" # Texte en rouge gras
    echo
}

# Exécuter la vérification et l'installation de gum si nécessaire
check_and_install_gum

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

# Vérifier si tous les liens symboliques ont été créés
check_all_symlinks_created() {
    list_symlinks
    directories=("📂 Téléchargement" "🖼️ Images" "📸 Photos" "🎥 Vidéos" "🎵 Musique" "📄 Documents" "📁 Stockage Interne")
    created_symlinks=0
    for dir in "${directories[@]}"; do
        if [[ " ${symlinks[@]} " =~ " ${dir} " ]]; then
            ((created_symlinks++))
        fi
    done
    if [ $created_symlinks -eq ${#directories[@]} ]; then
        clear
        show_banner
        echo "Tous les liens symboliques ont été créés."
        echo
        exit 0
    fi
}

# Fonction pour gérer la suppression des liens symboliques
delete_symlinks() {
    list_symlinks
    symlinks+=("Tous les répertoires" "Terminer") # Ajouter les options
    while true; do
        if [ ${#symlinks[@]} -eq 2 ]; then
            clear
            show_banner
            echo "Aucun lien symbolique à supprimer."
            break
        fi
        echo "Suppression de lien symbolique"
        echo
        if $USE_GUM; then
            selected_symlinks=$(printf "%s\n" "${symlinks[@]}" | gum choose --limit 1 --height=11)
        else
            for i in "${!symlinks[@]}"; do
                echo "$((i+1))) ${symlinks[i]}"
            done
            echo
            read -p "Entrez le numéro de votre choix : " choice
            selected_symlinks="${symlinks[$((choice-1))]}"
        fi
        if [ -n "$selected_symlinks" ]; then
            if [[ "$selected_symlinks" == "Terminer" ]]; then
                clear
                show_banner
                echo "Fin de la suppression."
                break
            elif [[ "$selected_symlinks" == "Tous les répertoires" ]]; then
                clear
                show_banner
                echo "Tous les liens symboliques ont été supprimé."
                echo
                for link in "${symlinks[@]}"; do
                    if [[ "$link" != "Terminer" && "$link" != "Tous les répertoires" ]]; then
                        rm "$HOME/$link"
                    fi
                done
                exit 0 # Terminer le script après suppression
            else
                echo "Suppression du lien symbolique : $selected_symlinks"
                rm "$HOME/$selected_symlinks"
                symlinks=("${symlinks[@]/$selected_symlinks}")
            fi
            clear
            show_banner
        fi
    done
}

# Mode suppression
if [[ "$1" == "--uninstall" || "$1" == "-u" ]]; then
    delete_symlinks
    exit 0
fi

# Vérifier si tous les liens symboliques ont déjà été créés au démarrage
check_all_symlinks_created

# Liste des répertoires possibles
directories=("📂 Téléchargement" "🖼️ Images" "📸 Photos" "🎥 Vidéos" "🎵 Musique" "📄 Documents" "📁 Stockage Interne")

# Fonction pour afficher et gérer la sélection des répertoires
display_directories() {
    list_symlinks
    filtered_directories=()
    for dir in "${directories[@]}"; do
        if [[ ! " ${symlinks[@]} " =~ " ${dir} " ]]; then
            filtered_directories+=("$dir")
        fi
    done
    filtered_directories+=("Tous les répertoires" "Terminer")
    while true; do
        echo "Création de lien symbolique"
        echo
        if $USE_GUM; then
            selected_dirs=$(printf "%s\n" "${filtered_directories[@]}" | gum choose --limit 1 --height=11)
        else
            for i in "${!filtered_directories[@]}"; do
                echo "$((i+1))) ${filtered_directories[i]}"
            done
            echo
            read -p "Entrez le numéro de votre choix : " choice
            if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#filtered_directories[@]}" ]; then
                display_error_message
                continue
            fi
            selected_dirs="${filtered_directories[$((choice-1))]}"
        fi
        if [ -n "$selected_dirs" ]; then
            if [[ "$selected_dirs" == "Terminer" ]]; then
                clear
                show_banner
                echo "Script terminé !"
                echo
                exit 0
            elif [[ "$selected_dirs" == "Tous les répertoires" ]]; then
                for dir in "${directories[@]}"; do
                    if [[ ! " ${symlinks[@]} " =~ " ${dir} " ]]; then
                        case $dir in
                            "📂 Téléchargement")
                                ln -s "$HOME/storage/downloads" "$HOME/📂 Téléchargement"
                                ;;
                            "🖼️ Images")
                                ln -s "$HOME/storage/pictures" "$HOME/🖼️ Images"
                                ;;
                            "📸 Photos")
                                ln -s "$HOME/storage/dcim" "$HOME/📸 Photos"
                                ;;
                            "🎥 Vidéos")
                                ln -s "$HOME/storage/movies" "$HOME/🎥 Vidéos"
                                ;;
                            "🎵 Musique")
                                ln -s "$HOME/storage/music" "$HOME/🎵 Musique"
                                ;;
                            "📄 Documents")
                                ln -s "$HOME/storage/documents" "$HOME/📄 Documents"
                                ;;
                            "📁 Stockage Interne")
                                ln -s "$HOME/storage/shared" "$HOME/📁 Stockage Interne"
                                ;;
                        esac
                        check_all_symlinks_created # Vérification après chaque création
                    fi
                done
                exit 0 # Terminer le script après création
            else
                echo "Création de lien symbolique pour : $selected_dirs"
                case $selected_dirs in
                    "📂 Téléchargement")
                        ln -s "$HOME/storage/downloads" "$HOME/📂 Téléchargement"
                        ;;
                    "🖼️ Images")
                        ln -s "$HOME/storage/pictures" "$HOME/🖼️ Images"
                        ;;
                    "📸 Photos")
                        ln -s "$HOME/storage/dcim" "$HOME/📸 Photos"
                        ;;
                    "🎥 Vidéos")
                        ln -s "$HOME/storage/movies" "$HOME/🎥 Vidéos"
                        ;;
                    "🎵 Musique")
                        ln -s "$HOME/storage/music" "$HOME/🎵 Musique"
                        ;;
                    "📄 Documents")
                        ln -s "$HOME/storage/documents" "$HOME/📄 Documents"
                        ;;
                    "📁 Stockage Interne")
                        ln -s "$HOME/storage/shared" "$HOME/📁 Stockage Interne"
                        ;;
                esac
                check_all_symlinks_created # Vérification après chaque création
                filtered_directories=("${filtered_directories[@]/$selected_dirs}")
            fi
            clear
            show_banner
        fi
    done
}

# Boucle principale
display_directories

# Effacer le terminal et afficher la bannière avant de terminer
clear
show_banner
if $USE_GUM; then
    clear
    show_banner
    gum style --foreground 212 --bold "Script terminé !"
else
    clear
    show_banner
    echo "Script terminé !"
fi