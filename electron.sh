#!/data/data/com.termux/files/usr/bin/bash

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
        echo "Installation de gum..."
        pkg install gum -y
    fi
}

# Fonction pour afficher la bannière avec ou sans gum
show_banner() {
    clear
    if $USE_GUM; then
        gum style \
            --foreground 212 \
            --border-foreground 212 \
            --align center \
            --width 40 \
            --margin "1 2" \
            "Oh-My-Termux" \
            "Electron Node.js"
    else
        echo "Oh-My-Termux"
        echo "Electron Node.js"
    fi
}

# Appel de la fonction pour vérifier et installer gum
check_and_install_gum

# Afficher la bannière
show_banner

# Désinstallation si le paramètre --uninstall ou -u est passé
if [[ "$1" == "--uninstall" || "$1" == "-u" ]]; then
    show_banner
    if $USE_GUM; then
        if gum confirm "Désinstaller Electron Node.js ?"; then
            echo "Désinstallation d'Electron Node.js ..."
            gum spin --spinner dot --title "Désinstallation de Node.js ..." -- pkg uninstall nodejs nodejs-lts -y
            gum spin --spinner dot --title "Désinstallation d'Electron ..." -- pkg uninstall electron -y
            # Supprimer le fichier de configuration des variables d'environnement
            if [ -f "$PREFIX/etc/profile.d/electron-nodejs.sh" ]; then
                rm "$PREFIX/etc/profile.d/electron-nodejs.sh"
                echo "Fichier de configuration des variables supprimé."
            fi
            echo "Désinstallation terminée !"
        fi
    else
        read -p "Désinstaller Electron Nodejs ? (o/n) " confirm
        if [[ $confirm =~ ^[Oo]$ ]]; then
            echo "Désinstallation d'Electron Node.js ..."
            pkg uninstall nodejs nodejs-lts -y
            pkg uninstall electron -y
            # Supprimer le fichier de configuration des variables d'environnement
            if [ -f "$PREFIX/etc/profile.d/electron-nodejs.sh" ]; then
                rm "$PREFIX/etc/profile.d/electron-nodejs.sh"
                echo "Fichier de configuration des variables supprimé."
            fi
            echo "Désinstallation terminée !"
        fi
    fi
    exit 0
fi

echo ""
if $USE_GUM; then
    if gum confirm "Installer Electron Node.js dans Termux ?"; then
        if [ "$(getprop ro.build.version.release)" -lt 7 ]; then
            echo "Les versions Android inférieures à 7 ne sont pas prises en charge !"
            exit 1
        fi
        gum spin --spinner dot --title "Mise à jour des paquets ..." -- pkg upgrade -y
        gum spin --spinner dot --title "Installation des dépôts requis ..." -- pkg install tur-repo x11-repo -y
        clear
        show_banner
        echo ""
        version=$(gum choose --limit 1 --height=5 "nodejs" "nodejs-lts")
        case $version in
            "nodejs")
                gum spin --spinner dot --title "Installation de nodejs ..." -- pkg install nodejs -y
                ;;
            "nodejs-lts")
                gum spin --spinner dot --title "Installation de nodejs-lts ..." -- pkg install nodejs-lts -y
                ;;
            *)
                echo "Erreur !" && exit
                ;;
        esac
        clear
        show_banner
        echo ""
        gum spin --spinner dot --title "Installation d'Electron..." -- pkg install electron -y
        echo "Modification des variables..."
        cat <<EOF > $PREFIX/etc/profile.d/electron-nodejs.sh
#!/data/data/com.termux/files/usr/bin/bash
export ELECTRON_SKIP_BINARY_DOWNLOAD=1
export ELECTRON_OVERRIDE_DIST_PATH=/data/data/com.termux/files/usr/bin
EOF
        source $PREFIX/etc/profile.d/electron-nodejs.sh
        echo "Installation d'Electron Node.js terminée !"
    fi
else
    read -p "Installer Electron Node.js dans Termux ? (o/n) " confirm
    if [[ $confirm =~ ^[Oo]$ ]]; then
        if [ "$(getprop ro.build.version.release)" -lt 7 ]; then
            echo "Les versions Android inférieures à 7 ne sont pas prises en charge !"
            exit 1
        fi
        echo "Mise à jour des paquets ..."
        pkg upgrade -y
        echo "Installation des dépôts requis ..."
        pkg install tur-repo x11-repo -y
        clear
        show_banner
        echo ""
        echo "Sélectionner la version de nodejs à installer :"
        echo ""
        echo "1) nodejs"
        echo "2) nodejs-lts"
        echo ""
        read -p "Choix : " version
        case $version in
            1)
                echo "Installation de nodejs ..."
                pkg install nodejs -y
                ;;
            2)
                echo "Installation de nodejs-lts ..."
                pkg install nodejs-lts -y
                ;;
            *)
                echo "Erreur !" && exit
                ;;
        esac
        clear
        show_banner
        echo ""
        echo "Installation d'Electron ..."
        pkg install electron -y
        cat <<EOF > $PREFIX/etc/profile.d/electron-nodejs.sh
#!/data/data/com.termux/files/usr/bin/bash
export ELECTRON_SKIP_BINARY_DOWNLOAD=1
export ELECTRON_OVERRIDE_DIST_PATH=/data/data/com.termux/files/usr/bin
EOF
        source $PREFIX/etc/profile.d/electron-nodejs.sh
        echo "Installation d'Electron Node.js terminée !"
    fi
fi