#!/bin/bash

GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RED="\e[31m"
RESET="\e[0m"

#TARGET DIRECTORY (BY DEFAULT-: CURRENT)
dir="${1:-.}"

#CHECK IF DIRECTORY EXISTS
if [ ! -d "$dir" ]; then
  echo -e "${RED}Error:${RESET} Directory '$dir' not found!"
  exit 1
fi

echo -e "${CYAN}========== DIRECTORY ANALYZER ==========${RESET}"
echo -e "Target Directory: ${YELLOW}$dir${RESET}"
echo

#COUNT TOTAL FILES AND DIRECTORIES
total_files=$(find "$dir" -type f 2>/dev/null | wc -l)
total_dirs=$(find "$dir" -type d 2>/dev/null | wc -l)
total_size=$(du -sh "$dir" 2>/dev/null | awk '{print $1}')

echo -e "${GREEN}Total files:${RESET} $total_files"
echo -e "${GREEN}Total directories:${RESET} $total_dirs"
echo -e "${GREEN}Total size:${RESET} $total_size"
echo

#TOP 5 LARGEST FILES
echo -e "${YELLOW}🔥 Top 5 Largest Files:${RESET}"
find "$dir" -type f -exec du -h {} + 2>/dev/null | sort -rh | head -n 5 | awk '{print $2 " — " $1}'
echo

#TOP 5 LARGEST DIRECTORIES
echo -e "${YELLOW}🏗️ Top 5 Largest Directories:${RESET}"
du -h --max-depth=1 "$dir" 2>/dev/null | sort -rh | head -n 6 | tail -n +2 | awk '{print $2 " — " $1}'
echo

#FILE TYPE COUNT(BY EXTENSION)
find "$dir" -type f 2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -nr | head -n 10 | awk '{print $2 " - " $1 " files"}'
echo

#LAST MODIFIED FILE
latest_file=$(find "$dir" -type f -printf "%T@ %p\n" 2>/dev/null | sort -nr | head -n 1 | cut -d' ' -f2-)
if [ -n "$latest_file" ]; then
  mod_time=$(date -r "$latest_file" "+%Y-%m-%d %H:%M")
  echo -e "${YELLOW}🕒 Last Modified:${RESET} $mod_time — ${latest_file}"
else
  echo -e "${YELLOW}🕒 Last Modified:${RESET} No files found"
fi


echo
echo -e "${CYAN}=========================================${RESET}"

