#!/bin/bash

RESET="\033[0m"          # Normal Colour
RED="\033[0;31m"         # Error / Issues
GREEN="\033[0;32m"       # Successful
BOLD="\033[01;01m"       # Highlight
WHITE="\033[1;37m"       # Bold Text
BLINK="\033[5m"          # Blinking Effect
CYAN="\033[0;36m"        # Info
MAGENTA="\033[0;35m"     # Tool Header Color
BLUE="\033[0;34m"        # Progress
LIGHT_BLUE="\033[1;34m"  # Light Blue Color for Progress
PURPLE="\033[0;35m"      # Purple
LIGHT_CYAN="\033[1;36m"  # Light Cyan
ORANGE="\033[0;33m"      # Orange for highlights
LIGHT_GREEN="\033[1;32m" # Light Green for success

start_time=$(date +%s)

clear
echo -e "${MAGENTA}==================================================================================${RESET}"

echo -e " _______  __   __  _______  __   __  _______  _______  _______  _______  ______   "
echo -e "|       ||  | |  ||  _    ||  |_|  ||   _   ||       ||       ||       ||    _ |  "
echo -e "|  _____||  | |  || |_|   ||       ||  |_|  ||    _  ||    _  ||    ___||   | ||  "
echo -e "| |_____ |  |_|  ||       ||       ||       ||   |_| ||   |_| ||   |___ |   |_||_ "
echo -e "|_____  ||       ||  _   | |       ||       ||    ___||    ___||    ___||    __  |"
echo -e " _____| ||       || |_|   || ||_|| ||   _   ||   |    |   |    |   |___ |   |  | |"
echo -e "|_______||_______||_______||_|   |_||__| |__||___|    |___|    |_______||___|  |_|"

echo -e "${MAGENTA}==================================================================================${RESET}"

current_date_time=$(date '+%Y-%m-%d %H:%M:%S') # Get current date and time
echo -e "${LIGHT_BLUE}=================================================================================="
echo -e "${LIGHT_CYAN}                            Subdomain Enumeration Tool                           "
echo -e "${LIGHT_BLUE}=================================================================================="
echo -e " "
echo -e "${WHITE}                              ${BLINK}Author: manojxshrestha${RESET}${WHITE}           "
echo -e "${WHITE}                             ${BLINK}Date: $current_date_time${RESET}${WHITE}           "
echo -e "=================================================================================="
echo -e " "

echo -e "${GREEN}[*] Starting Subdomain Enumeration...${RESET}"
echo -e "\n"

read -p "Enter the Target Domain (e.g. example.com): " domain

if [ -z "$domain" ]; then
    echo -e "${RED}[!] No domain provided. Exiting...${RESET}"
    exit 1
fi

mkdir -p "$domain/subdomains"

fetch_subdomains() {
    echo -e "${GREEN}[+] Collecting Subdomains from $1...${RESET}"
    eval "$2" >> "$domain/subdomains/$1.txt"
}

fetch_json_subdomains() {
    echo -e "${GREEN}[+] Collecting Subdomains from $1 API...${RESET}"
    
    response=$(curl -s "$2")
    
    if echo "$response" | jq . > /dev/null 2>&1; then
        echo "$response" | jq "$3" | grep -Po "$4" >> "$domain/subdomains/$1.txt"
    else
        echo -e "${RED}[!] Invalid or Non-JSON Response from $1 API${RESET}"
    fi
}

fetch_subdomains "Amass" "amass enum -passive -d $domain -o /dev/null"

fetch_subdomains "Assetfinder" "assetfinder --subs-only $domain"

fetch_subdomains "Subfinder" "subfinder -d $domain -silent"

fetch_json_subdomains "crt.sh" "https://crt.sh/?q=%25.$domain&output=json" '.[].name_value' "\w.*$domain"

fetch_subdomains "Archive" "curl -s \"http://web.archive.org/cdx/search/cdx?url=*.$domain/*&output=text&fl=original&collapse=urlkey\" | sed -e 's_https*://__' -e \"s/\/.*//\""

echo -e "${GREEN}[+] Combining Results, Removing Duplicates, and Filtering...${RESET}"
cat "$domain/subdomains/"*.txt | sort -u | grep -v '^$' | uniq > "$domain/all_subdomains.txt"
rm -rf "$domain/subdomains"

end_time=$(date +%s)  
execution_time=$((end_time - start_time))  

if ((execution_time < 60)); then
    echo -e "${GREEN}[+] Subdomain Enumeration Finished in $execution_time seconds${RESET}"
else
    minutes=$((execution_time / 60))  
    seconds=$((execution_time % 60))  
    echo -e "${GREEN}[+] Subdomain Enumeration Finished in $minutes minutes and $seconds seconds${RESET}"
fi

if [ -f "$domain/all_subdomains.txt" ]; then
    echo -e "${GREEN}[+] Results saved in $domain/all_subdomains.txt${RESET}"
else
    echo -e "${RED}[!] No results found. Please check the domain and try again.${RESET}"
fi
