#!/bin/bash

clear
echo -e "\e[1;32mWelcome to Dynamic Elite Terminal Setup!\e[0m"
echo "=========================================="

# User er kach theke nam neya hocche
read -p "Enter your name for the banner: " USER_NAME

echo -e "\n\e[1;36mInstalling required packages...\e[0m"
pkg update -y > /dev/null 2>&1
pkg install figlet wget ncurses-utils -y > /dev/null 2>&1

echo -e "\n\e[1;36mDownloading ANSI Shadow Font...\e[0m"
mkdir -p ~/.figlet_fonts
wget -qO ~/.figlet_fonts/ANSI_Shadow.flf https://raw.githubusercontent.com/xero/figlet-fonts/master/ANSI%20Shadow.flf

echo -e "\e[1;36mApplying final design...\e[0m"

# Notun kore .bashrc file toiri kora hocche ebong nam save kora hocche
echo "MY_NAME=\"$USER_NAME\"" > ~/.bashrc

# Baki design .bashrc te add kora hocche
cat << 'EOF' >> ~/.bashrc

# Banner print korar main function
print_banner() {
    # ==========================================
    # RANDOM THEME GENERATOR (Rong auto change hobe)
    # ==========================================
    THEME=$((RANDOM % 4))

    if [ $THEME -eq 0 ]; then
        # Theme 1: Pink & Deep Blue
        TOP_C='\033[38;5;213m' 
        BOT_C='\033[38;5;27m'  
        BORD_C='\033[38;5;63m' 
        ICON_C='\033[38;5;51m' 
    elif [ $THEME -eq 1 ]; then
        # Theme 2: Yellow & Green
        TOP_C='\033[38;5;226m' 
        BOT_C='\033[38;5;46m'  
        BORD_C='\033[38;5;154m' 
        ICON_C='\033[38;5;51m' 
    elif [ $THEME -eq 2 ]; then
        # Theme 3: Cyan & Blue
        TOP_C='\033[38;5;51m'  
        BOT_C='\033[38;5;33m'  
        BORD_C='\033[38;5;39m' 
        ICON_C='\033[38;5;226m'
    else
        # Theme 4: White & Neon Green
        TOP_C='\033[1;37m'     
        BOT_C='\033[38;5;46m'  
        BORD_C='\033[1;32m'    
        ICON_C='\033[38;5;51m' 
    fi

    RED='\033[1;31m'
    W='\033[1;37m'
    NC='\033[0m'

    # Screen er map (width) neya hocche
    TERM_COLS=$(tput cols)
    if [ -z "$TERM_COLS" ] || [ "$TERM_COLS" -lt 40 ]; then TERM_COLS=55; fi
    if [ "$TERM_COLS" -gt 60 ]; then TERM_COLS=60; fi

    echo ""

    # ANSI Shadow font diye namer 3D art toiri
    mapfile -t ASCII_ART < <(figlet -f ~/.figlet_fonts/ANSI_Shadow.flf "$MY_NAME")
    TOTAL_LINES=${#ASCII_ART[@]}
    HALF_LINES=$((TOTAL_LINES / 2))

    for (( i=0; i<TOTAL_LINES; i++ )); do
        line="${ASCII_ART[$i]}"
        line_length=${#line}

        PAD_NAME=$(( (TERM_COLS - line_length) / 2 ))
        if [ $PAD_NAME -lt 0 ]; then PAD_NAME=0; fi

        if [ $i -lt $HALF_LINES ]; then
            printf "%${PAD_NAME}s${TOP_C}%s\n" "" "$line"
        else
            printf "%${PAD_NAME}s${BOT_C}%s\n" "" "$line"
        fi
    done

    # Subtitle ba nicher choto lekha
    SUB_STR="* E L I T E   T E R M I N A L *"
    PAD_SUB=$(( (TERM_COLS - 31) / 2 ))
    if [ $PAD_SUB -lt 0 ]; then PAD_SUB=0; fi
    printf "%${PAD_SUB}s${RED}%s${NC}\n" "" "$SUB_STR"

    # Uporer mota border line
    printf "${BORD_C}"
    for ((i=0; i<TERM_COLS; i++)); do printf "━"; done
    printf "${NC}\n\n"

    BOX_WIDTH=$((TERM_COLS - 2))

    print_border_line() {
        local left=$1; local mid=$2; local right=$3
        printf "${BORD_C}$left"
        for ((i=0; i<BOX_WIDTH-2; i++)); do printf "$mid"; done
        printf "$right${NC}\n"
    }

    # Real-time data fetch kora hocche (Clear dile update hobe)
    IP=$(ifconfig wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}')
    if [ -z "$IP" ]; then IP="192.168.0.105"; fi
    DATE_STR="$(date '+%d %B %Y   ·   %A')"
    TIME_STR="$(date '+%I:%M:%S %p')"
    STRG_STR="$(df -h /data | awk 'NR==2 {print $4" free / "$2}')"
    MEM_STR="$(free -m | awk 'NR==2 {print $7"/"$2" MB"}')"

    # Box er vitorer lekha gulo thik vabe sajano
    print_row() {
        local icon="$1"
        local text_label="$2"
        local value="$3"

        local padded_label=$(printf "%-7s" "$text_label")
        local val_len=${#value}
        
        local content_len=$(( 2 + 7 + 3 + val_len ))
        local padding=$(( BOX_WIDTH - content_len - 4 ))
        if [ $padding -lt 0 ]; then padding=0; fi

        printf "${BORD_C}║ ${ICON_C}%s ${W}%s${BORD_C} │ ${W}%s" "$icon" "$padded_label" "$value"
        for ((i=0; i<padding; i++)); do printf " "; done
        printf "${BORD_C} ║\n"
    }

    # Main Box toiri kora
    print_border_line "╔" "═" "╗"
    print_row "■" "DATE" "$DATE_STR"
    print_row "⊙" "TIME" "$TIME_STR"
    print_border_line "╠" "═" "╣"
    print_row "●" "NETWORK" "$IP"
    print_row "■" "STORAGE" "$STRG_STR"
    print_row "✦" "MEMORY" "$MEM_STR"
    print_border_line "╚" "═" "╝"

    # Nicher mota border line
    printf "${BORD_C}"
    for ((i=0; i<TERM_COLS; i++)); do printf "━"; done
    printf "${NC}\n" 

    # Ekdom nicher motivational text
    TXT_STR="- In zeros and ones - you are the one. -"
    PAD_TXT=$(( (TERM_COLS - ${#TXT_STR}) / 2 ))
    printf "%${PAD_TXT}s${W}%s${NC}\n\n" "" "$TXT_STR"
}

# 'clear' command ke modify (alias) kora holo jate clear dilei banner ashe
alias clear='command clear; print_banner'

# Terminal open korle prothom bar banner dekhabe
command clear
print_banner

# Love emoji (♥) diye prompt design
export PS1="\[\e[38;5;46m\]╭─\[\e[1;37m\][\[\e[1;36m\]\w\[\e[1;37m\]] \[\e[1;31m\]♥\n\[\e[38;5;46m\]╰─>>\[\e[0m\] "
EOF

echo -e "\n\e[1;32mInstallation Complete!\e[0m"
echo -e "Type \e[1;33msource ~/.bashrc\e[0m to apply changes."
