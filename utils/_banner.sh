#!/bin/bash
#
# Print banner art.

#######################################
# Print a board. 
# Globals:
#   BG_BROWN
#   NC
#   WHITE
#   CYAN_LIGHT
#   RED
#   GREEN
#   YELLOW
# Arguments:
#   None
#######################################
print_banner() {

  clear

  printf "\n\n"

printf "${CYAN_LIGHT}";  
printf "██████╗░██╗░░░░░░██╗░░░░░░░██╗\n";
printf "██╔══██╗██║░░░░░░██║░░██╗░░██║\n";
printf "██████╔╝██║░░░░░░╚██╗████╗██╔╝\n";
printf "██╔═══╝░██║░░░░░░░████╔═████║░\n";
printf "██║░░░░░███████╗░░╚██╔╝░╚██╔╝░\n";
printf "╚═╝░░░░░╚══════╝░░░╚═╝░░░╚═╝░░\n";
printf "\n";
printf "ESSE MATERIAL FAZ PARTE DO CLUB VIP PLW\n";
printf "\n";
printf " © Club Vip PLW - vip.plwdesign.online\n";
printf "${NC}";

printf "\n"
}
