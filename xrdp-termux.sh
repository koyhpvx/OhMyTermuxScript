#!/bin/bash

# Vérifier si le script est exécuté dans Termux
if [ ! -d "/data/data/com.termux" ]; then
    echo "Ce script doit être exécuté dans Termux."
    exit 1
fi

# Mise à jour des paquets Termux...
echo "Mise à jour des paquets Termux..."
clear && pkg update -y

# Variables pour déterminer si gum doit être utilisé et si une désinstallation est demandée
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
            --border double \
            --align center \
            --width 40 \
            --margin "1 2" \
            --padding "1 1" \
            "Oh-My-Termux" \
            "     xRDP    " \
            ""
    else
        echo -e "\e[1;34mOh-My-Termux\e[0m"
        echo -e "\e[1;35m     xRDP     \e[0m"
        echo
    fi
}

# Fonction pour désinstaller les modifications
uninstall_changes() {
    echo "Désinstallation de xRDP et suppression des modifications..."
    if $USE_GUM; then
        gum spin --spinner dot --title "Désinstallation de xRDP ..." -- pkg uninstall xrdp -y
    else
        pkg uninstall xrdp -y
    fi

    # Supprimer les alias de configuration
    sed -i '/alias stopxrdp/d' "$CONFIG_FILE"
    sed -i '/alias startxrdp/d' "$CONFIG_FILE"
    echo "Modifications désinstallées avec succès."
}

# Détecter le shell actif
SHELL_NAME=$(basename $SHELL)

# Définir le fichier de configuration en fonction du shell
case $SHELL_NAME in
    bash)
        CONFIG_FILE="$HOME/.bashrc"
    ;;
    zsh)
        CONFIG_FILE="$HOME/.zshrc"
    ;;
    fish)
        CONFIG_FILE="$HOME/.config/fish/config.fish"
    ;;
    *)
        echo "Shell non supporté : $SHELL_NAME"
        exit 1
    ;;
esac

# Si le paramètre de désinstallation est fourni, exécuter la désinstallation et quitter
if $UNINSTALL; then
    uninstall_changes
    exit 0
fi

# Appeler la fonction pour vérifier et installer gum
check_and_install_gum

# Afficher la bannière
show_banner

# Installer xRDP avec un spinner si gum est utilisé
if $USE_GUM; then
    gum spin --spinner dot --title "Installation de xRDP ..." -- pkg install xrdp xfce4 -y
else
    pkg install xrdp xfce4 -y
fi

# Vérifier si xfce4 est installé
if ! command -v startxfce4 &> /dev/null; then
    echo "Erreur : xfce4 n'a pas pu être installé. Veuillez l'installer manuellement."
    exit 1
fi

# Configurer xRDP
sed -i 's/port=-1/port=5901/' $PREFIX/etc/xrdp/xrdp.ini

# Ajouter des alias pour démarrer et arrêter xRDP
echo 'alias stopxrdp="xrdp -k && vncserver -kill :1"' >> $CONFIG_FILE
echo 'alias startxrdp="xrdp && vncserver -xstartup /usr/bin/startxfce4 -listen tcp :1 && ifconfig"' >> $CONFIG_FILE

# Recharger le fichier de configuration pour rendre les alias disponibles dans la session actuelle
if [ "$SHELL_NAME" = "fish" ]; then
    source $CONFIG_FILE
else
    . $CONFIG_FILE
fi

# Configurer le serveur VNC et le mot de passe
xrdp && vncserver -xstartup /usr/bin/startxfce4 -listen tcp :1 && stopxrdp

# Informer l'utilisateur que l'installation est terminée
clear && echo "XRDP est installé. Pour l'utiliser, tapez \"startxrdp && ifconfig\" et connectez-vous à l'IP locale WLAN0 avec votre PC. Vous pouvez fermer xrdp en tapant \"stopxrdp\"."