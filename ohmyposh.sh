#!/data/data/com.termux/files/usr/bin/bash

# Mise à jour des paquets Termux
echo "Mise à jour des paquets Termux..."
clear && pkg update -y

# Variables pour déterminer si gum doit être utilisé et si une désinstallation doit être effectuée
USE_GUM=false
UNINSTALL=false

# Vérification des arguments
for arg in "$@"; do
    case $arg in
        --gum|-g)
            USE_GUM=true
            shift
            ;;
        --uninstall|-u)
            UNINSTALL=true
            shift
            ;;
    esac
done

# Fonction pour vérifier et installer gum
check_and_install_gum() {
    if $USE_GUM && ! command -v gum &> /dev/null; then
        echo "Installation de gum..."
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
            --align center \
            --width 25 \
            --margin "1 2" \
            "Oh-My-Termux" \
            "Oh-My-Posh"
    else
        echo "Oh-My-Termux"
        echo "Oh-My-Posh"
    fi
}

# Fonction pour désinstaller Oh-My-Posh
uninstall_oh_my_posh() {
    show_banner
    echo "Désinstallation de Oh-My-Posh..."

    # Supprimer Oh-My-Posh
    pkg uninstall -y oh-my-posh

    # Supprimer la ligne de configuration du fichier de configuration du shell
    sed -i '/oh-my-posh init/d' "$CONFIG_FILE"

    # Supprimer la police téléchargée
    rm -f "$HOME/.termux/font.ttf"

    # Recharger le fichier de configuration du shell
    eval "$EXEC_CMD"

    echo "Désinstallation terminée."
    exit 0
}

# Détection du shell
SHELL_NAME=$(basename "$SHELL")

# Définition du fichier de configuration en fonction du shell
case $SHELL_NAME in
  bash)
    CONFIG_FILE="$HOME/.bashrc"
    EXEC_CMD="source ~/.bashrc"
    ;;
  zsh)
    CONFIG_FILE="$HOME/.zshrc"
    EXEC_CMD="source ~/.zshrc"
    ;;
  fish)
    CONFIG_FILE="$HOME/.config/fish/config.fish"
    EXEC_CMD="source ~/.config/fish/config.fish"
    ;;
  *)
    echo "Shell non supporté : $SHELL_NAME"
    exit 1
    ;;
esac

# Si le paramètre de désinstallation est fourni, exécuter la désinstallation et quitter
if $UNINSTALL; then
    uninstall_oh_my_posh
fi

# Appel de la fonction pour vérifier et installer gum
check_and_install_gum

# Afficher la bannière
show_banner

# Utilisation de gum pour confirmer l'installation de Oh-My-Posh
if $USE_GUM; then
    gum confirm "Installer Oh-My-Posh ?" || { echo "Installation annulée."; exit 0; }
fi

# Vérification de la présence de Oh-My-Posh
if ! command -v oh-my-posh &> /dev/null; then
    echo "Installation de Oh-My-Posh via pkg..."
    pkg install -y oh-my-posh
fi

# Télécharger et installer la police DejaVu Sans Mono
show_banner
echo "Téléchargement de la police DejaVu Sans Mono..."
curl -fLo "$HOME/.termux/font.ttf" --create-dirs https://raw.githubusercontent.com/termux/termux-styling/master/app/src/main/assets/fonts/DejaVu-Sans-Mono.ttf

# Ligne à ajouter pour Oh My Posh
LINE_TO_ADD='eval "$(oh-my-posh init bash --config /data/data/com.termux/files/usr/share/oh-my-posh/themes/jandedobbeleer.omp.json)"'

# Vérifier si la ligne est déjà présente, sinon l'ajouter
if ! grep -qF "$LINE_TO_ADD" "$CONFIG_FILE"; then
  show_banner
  echo "Ajout de la configuration Oh-My-Posh au fichier $CONFIG_FILE"
  echo "$LINE_TO_ADD" >> "$CONFIG_FILE"
else
  echo "La configuration Oh-My-Posh est déjà présente dans $CONFIG_FILE"
fi

# Rechargement des paramètres de Termux
termux-reload-settings

clear
# Exécuter la commande exec appropriée pour recharger le shell
eval "$EXEC_CMD"

echo "Installation et configuration terminées."