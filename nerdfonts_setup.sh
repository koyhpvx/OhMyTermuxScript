#!/data/data/com.termux/files/usr/bin/bash

# Répertoire de téléchargement des polices
FONTS_DIR="$HOME/.termux/fonts"
CURRENT_FONT_FILE="$HOME/.termux/font.ttf"

# Crée le répertoire s'il n'existe pas
mkdir -p "$FONTS_DIR"

# Fonction pour télécharger une police
download_font() {
    local font_name="$1"
    local font_url="$2"
    echo "Téléchargement de $font_name..."
    curl -L -o "$FONTS_DIR/$font_name" "$font_url"
}

# Fonction pour lister les polices installées
list_installed_fonts() {
    echo "Polices installées :"
    ls -1 "$FONTS_DIR"
}

# Fonction pour lister les polices disponibles
list_available_fonts() {
    echo "Polices disponibles :"
    for font in "${!font_urls[@]}"; do
        echo "- $font"
    done
}

# Fonction pour définir la police active
set_font() {
    local font_name="$1"
    if [ -f "$FONTS_DIR/$font_name" ]; then
        cp "$FONTS_DIR/$font_name" "$CURRENT_FONT_FILE"
        echo "Police $font_name définie comme active."
        termux-reload-settings
    else
        echo "La police $font_name n'est pas installée."
    fi
}

# Fonction pour supprimer une police
remove_font() {
    local font_name="$1"
    if [ -f "$FONTS_DIR/$font_name" ]; then
        rm "$FONTS_DIR/$font_name"
        echo "Police $font_name supprimée."
    else
        echo "La police $font_name n'est pas installée."
    fi
}

# Tableau associatif des URLs des polices Nerd Fonts
declare -A font_urls
font_urls=(
    ["3270NerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/3270/Regular/3270NerdFontMono-Regular.ttf"
    ["AgaveNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Agave/AgaveNerdFontMono-Regular.ttf"
    ["AnonymiceProNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/AnonymousPro/Regular/AnonymiceProNerdFontMono-Regular.ttf"
    ["ArimoNerdFont-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Arimo/Regular/ArimoNerdFont-Regular.ttf"
    ["AurulentSansMNerdFontMono-Regular.otf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/AurulentSansMono/AurulentSansMNerdFontMono-Regular.otf"
    ["BigBlueTerm437NerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/BigBlueTerminal/BigBlueTerm437NerdFontMono-Regular.ttf"
    ["BitstromWeraNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/BitstreamVeraSansMono/Regular/BitstromWeraNerdFontMono-Regular.ttf"
    ["CaskaydiaCoveNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascadiaCode/Regular/CaskaydiaCoveNerdFontMono-Regular.ttf"
    ["BlexMonoNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/IBMPlexMono/Mono/BlexMonoNerdFontMono-Regular.ttf"
    ["CodeNewRomanNerdFontMono-Regular.otf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CodeNewRoman/Regular/CodeNewRomanNerdFontMono-Regular.otf"
    ["ComicShannsMonoNerdFontMono-Regular.otf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/ComicShannsMono/ComicShannsMonoNerdFontMono-Regular.otf"
    ["CousineNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Cousine/Regular/CousineNerdFontMono-Regular.ttf"
    ["DaddyTimeMonoNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DaddyTimeMono/DaddyTimeMonoNerdFontMono-Regular.ttf"
    ["DejaVuSansMNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/DejaVuSansMNerdFontMono-Regular.ttf"
    ["DroidSansMNerdFontMono-Regular.otf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/DroidSansMNerdFontMono-Regular.otf"
    ["FantasqueSansMNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FantasqueSansMono/Regular/FantasqueSansMNerdFontMono-Regular.ttf"
    ["FiraCodeNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFontMono-Regular.ttf"
    ["FiraMonoNerdFontMono-Regular.otf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraMono/Regular/FiraMonoNerdFontMono-Regular.otf"
    ["GohuFontuni14NerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Gohu/uni-14/GohuFontuni14NerdFontMono-Regular.ttf"
    ["GoMonoNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Go-Mono/Regular/GoMonoNerdFontMono-Regular.ttf"
    ["HackNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFontMono-Regular.ttf"
    ["HasklugNerdFontMono-Regular.otf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hasklig/Regular/HasklugNerdFontMono-Regular.otf"
    ["HurmitNerdFontMono-Regular.otf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hermit/Regular/HurmitNerdFontMono-Regular.otf"
    ["iMWritingMonoNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/iA-Writer/Mono/Regular/iMWritingMonoNerdFontMono-Regular.ttf"
    ["InconsolataNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Inconsolata/InconsolataNerdFontMono-Regular.ttf"
    ["InconsolataGoNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/InconsolataGo/Regular/InconsolataGoNerdFontMono-Regular.ttf"
    ["InconsolataLGCNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/InconsolataLGC/Regular/InconsolataLGCNerdFontMono-Regular.ttf"
    ["IosevkaNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Regular/IosevkaNerdFontMono-Regular.ttf"
    ["IosevkaTermNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/IosevkaTerm/Regular/IosevkaTermNerdFontMono-Regular.ttf"
    ["JetBrainsMonoNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFontMono-Regular.ttf"
    ["JetBrainsMonoNLNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/JetBrainsMono/NoLigatures/Regular/JetBrainsMonoNLNerdFontMono-Regular.ttf"
    ["LektonNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Lekton/Regular/LektonNerdFontMono-Regular.ttf"
    ["LiterationMonoNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/LiberationMono/LiterationMonoNerdFontMono-Regular.ttf"
    ["LilexNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Lilex/Regular/LilexNerdFontMono-Regular.ttf"
    ["MesloLGMNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/M/Regular/MesloLGMNerdFontMono-Regular.ttf"
    ["MonofurNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Monofur/Regular/MonofurNerdFontMono-Regular.ttf"
    ["MonoidNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Monoid/Regular/MonoidNerdFontMono-Regular.ttf"
    ["MononokiNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Mononoki/Regular/MononokiNerdFontMono-Regular.ttf"
    ["M%2B1CodeNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/MPlus/M_Plus_1_code/M%2B1CodeNerdFontMono-Regular.ttf"
    ["NotoMonoNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Noto/Mono/NotoMonoNerdFontMono-Regular.ttf"
    ["OpenDyslexicMNerdFontMono-Regular.otf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/OpenDyslexic/Mono-Regular/OpenDyslexicMNerdFontMono-Regular.otf"
    ["OverpassMNerdFontMono-Regular.otf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Overpass/Mono/Regular/OverpassMNerdFontMono-Regular.otf"
    ["ProFontIIxNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/ProFont/profontiix/ProFontIIxNerdFontMono-Regular.ttf"
    ["ProggyCleanSZNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/ProggyClean/SlashedZero/ProggyCleanSZNerdFontMono-Regular.ttf"
    ["RobotoMonoNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/RobotoMonoNerdFontMono-Regular.ttf"
    ["ShureTechMonoNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/ShareTechMono/ShureTechMonoNerdFontMono-Regular.ttf"
    ["SauceCodeProNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/SauceCodeProNerdFontMono-Regular.ttf"
    ["SpaceMonoNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SpaceMono/Regular/SpaceMonoNerdFontMono-Regular.ttf"
    ["SymbolsNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf"
    ["TerminessNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Terminus/Regular/TerminessNerdFontMono-Regular.ttf"
    ["TinosNerdFont-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Tinos/Regular/TinosNerdFont-Regular.ttf"
    ["UbuntuNerdFont-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Ubuntu/Regular/UbuntuNerdFont-Regular.ttf"
    ["UbuntuMonoNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/UbuntuMonoNerdFontMono-Regular.ttf"
    ["VictorMonoNerdFontMono-Regular.ttf"]="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/VictorMono/Regular/VictorMonoNerdFontMono-Regular.ttf"
)

# Menu principal
while true; do
    echo "
1. Télécharger une police
2. Lister les polices installées
3. Lister les polices disponibles
4. Définir la police active
5. Supprimer une police
6. Quitter
"
    read -p "Choisissez une option : " choice

    case $choice in
        1)
            read -p "Entrez le nom de la police à télécharger : " font_name
            if [ -n "${font_urls[$font_name]}" ]; then
                download_font "$font_name" "${font_urls[$font_name]}"
            else
                echo "Police non trouvée."
            fi
            ;;
        2) list_installed_fonts ;;
        3) list_available_fonts ;;
        4)
            read -p "Entrez le nom de la police à définir comme active : " font_name
            set_font "$font_name"
            ;;
        5)
            read -p "Entrez le nom de la police à supprimer : " font_name
            remove_font "$font_name"
            ;;
        6) exit 0 ;;
        *) echo "Option invalide." ;;
    esac
done