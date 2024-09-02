#!/bin/bash

USE_GUM=false

for arg in "$@"; do
    case $arg in
        --gum|-g)
            USE_GUM=true
            shift
            ;;
    esac
done

check_and_install_gum() {
    if $USE_GUM && ! command -v gum &> /dev/null; then
        echo -e "\e[38;5;33mInstallation de gum...\e[0m"
        pkg update -y > /dev/null 2>&1 && pkg install gum -y > /dev/null 2>&1
    fi
}

finish() {
    local ret=$?
    if [ ${ret} -ne 0 ] && [ ${ret} -ne 130 ]; then
        echo
        if $USE_GUM; then
            gum style --foreground 196 "ERREUR: Installation de OhMyTermux impossible."
        else
            echo -e "\e[38;5;196mERREUR: Installation de OhMyTermux impossible.\e[0m"
        fi
        echo -e "\e[38;5;33mVeuillez vous référer au(x) message(s) d'erreur ci-dessus.\e[0m"
    fi
}

trap finish EXIT

bash_banner() {
    clear
    COLOR="\e[38;5;33m"

    TOP_BORDER="╔════════════════════════════════════════╗"
    BOTTOM_BORDER="╚════════════════════════════════════════╝"
    EMPTY_LINE="║                                        ║"
    TEXT_LINE="║           OHMYTERMUXSCRIPT             ║"

    echo
    echo -e "${COLOR}${TOP_BORDER}"
    echo -e "${COLOR}${EMPTY_LINE}"
    echo -e "${COLOR}${TEXT_LINE}"
    echo -e "${COLOR}${EMPTY_LINE}"
    echo -e "${COLOR}${BOTTOM_BORDER}\e[0m"
    echo
}

show_banner() {
    clear
    if $USE_GUM; then
        gum style \
            --foreground 33 \
            --border-foreground 33 \
            --border double \
            --align center \
            --width 40 \
            --margin "1 1 1 0" \
            "" "OHMYTERMUXSCRIPT" ""
    else
       bash_banner
    fi
}

check_and_install_gum
show_banner

SCRIPT_DIR="$HOME/OhMyTermuxScript"

if [ ! -d "$SCRIPT_DIR" ]; then
    if $USE_GUM; then
      if gum confirm --prompt.foreground="33" --selected.background="33" "    Installer OhMyTermuxScript ?"; then
        gum spin --spinner.foreground="33" --title.foreground="33" --title="Installation de OhMyTermuxScript" -- bash -c 'git clone https://github.com/GiGiDKR/OhMyTermuxScript.git "$HOME/OhMyTermuxScript" && chmod +x $HOME/OhMyTermuxScript/*.sh'
      fi
    else
      echo -e "\e[38;5;33m    Installer OhMyTermuxScript ? (o/n)\e[0m"
      read -r choice
      if [ "$choice" = "o" ]; then
        echo -e "\e[38;5;33mInstallation de OhMyTermuxScript...\e[0m"
        git clone https://github.com/GiGiDKR/OhMyTermuxScript.git "$HOME/OhMyTermuxScript" && chmod +x $HOME/OhMyTermuxScript/*.sh
      fi
    fi
fi

execute_script() {
  if [ -d "$SCRIPT_DIR" ]; then
    mapfile -t scripts < <(find "$SCRIPT_DIR" -name "*.sh" -type f)

    script_names=()
    for script in "${scripts[@]}"; do
      script_names+=("$(basename "$script")")
    done

    while true; do
      show_banner
      echo -e "\e[38;5;33m            Sélection de script\n\e[0m"

      if $USE_GUM; then
        script_choice=$(gum choose --selected.foreground="33" --header.foreground="33" --cursor.foreground="33" "${script_names[@]}" "> Quitter")
        if [ "$script_choice" == "> Quitter" ]; then
          clear
          return
        fi
      else
        select script_choice in "${script_names[@]}" "Quitter"; do
          if [[ $REPLY -eq $(( ${#script_names[@]} + 1 )) ]]; then
            clear
            return
          elif [[ 1 -le $REPLY && $REPLY -le ${#script_names[@]} ]]; then
            selected_script="${scripts[$((REPLY-1))]}"
            break
          else
            show_banner
            echo -e "\e[38;5;196m         Aucun script correspondant\e[0m"
            sleep 1
            continue 2
          fi
        done
      fi
      if [ -n "$selected_script" ]; then
        bash "$selected_script"
      else
        echo "Aucun script sélectionné."
      fi
    done
  else
    echo "Le répertoire $SCRIPT_DIR n'existe pas."
  fi
}

if $USE_GUM; then
  if gum confirm --prompt.foreground="33" --selected.background="33" "      Exécuter un script ?"; then
    execute_script
  fi
else
  read -p "    Exécuter un script ? (o/n) " choice
  if [ "$choice" = "o" ]; then
    execute_script
  fi
fi