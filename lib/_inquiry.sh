#!/bin/bash

get_frontend_url() {
  print_banner
  printf "${WHITE} 💻 Digite o domínio da interface web (Frontend):${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " frontend_url
}

get_backend_url() {
  print_banner
  printf "${WHITE} 💻 Digite o domínio da sua API (Backend):${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " backend_url
}

get_frontend_port() {
  
  print_banner
  printf "${WHITE} 💻 Digite a porta da sua API (Frontend - entre 3335 e 3345):${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " frontend_port
}

get_backend_port() {
  
  print_banner
  printf "${WHITE} 💻 Digite a porta da sua API (Backend - entre 8090 e 8190):${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " backend_port
}

get_redis_port() {
  
  print_banner
  printf "${WHITE} 💻 Digite a porta do banco redis (Backend - entre 6380 e 6480):${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " redis_port
}

get_pg_port() {
  
  print_banner
  printf "${WHITE} 💻 Digite a porta do banco pg (Backend - entre 5440 e 5540):${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " pg_port
}

get_db_name() {
  
  print_banner
  printf "${WHITE} 💻 Digite o nome do banco de dados (ex.: zpro2):${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " db_name
}

get_folder_name() {
  
  print_banner
  printf "${WHITE} 💻 Digite o nome da nova pasta (ex.: zpro2):${GRAY_LIGHT}"
  printf "\n\n"
  read -p "> " folder_name
}

get_urls() {
  get_frontend_url
  get_backend_url
  get_backend_port
  get_frontend_port
  get_redis_port
  get_pg_port
  get_folder_name
}

inquiry_options() {
  
  print_banner
  printf "${WHITE} 💻 O que você precisa fazer?${GRAY_LIGHT}"
  printf "\n\n"
  printf "${GREEN} Antes de instalar, é obrigatório criar um snapshot (ponto de restauração) da sua VPS${NC}"
  printf "\n\n"
  printf "   [1] Instalar nova instância\n"
  printf "\n"
  read -p "> " option

  case "${option}" in
    1) get_urls ;;

    *) exit ;;
  esac
}

