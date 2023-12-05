#!/bin/bash

repo="295devops-travel-lamp"

USERID=$(id -u)

LRED='\033[1;31m'
LGREEN='\033[1;32m'
NC='\033[0m'
LBLUE='\033[0;34m'
LYELLOW='\033[1;33m'

check_status() {
  if [ $1 -eq 0 ]; then
    echo "Éxito"
    echo -e "\n${LGREEN} Éxito ...${NC}"
  else
    echo -e "\n${LRED} Error: El comando falló. Saliendo del script ...${NC}"
    exit 1
  fi
}

install_packages() {
  packages=("docker.io" "docker-compose" "git" "curl")

  for package in "${packages[@]}"; do
    dpkg -l | grep -q $package
    if [ $? -eq 0 ]; then
      echo -e "\n${LGREEN} $package ya está instalado ...${NC}"
    else
      echo -e "\n${LYELLOW}instalando $package ...${NC}"
      sudo apt-get install -y $package
      check_status $?
    fi
  done
}

build_application() {
    echo "====================================="
    echo -e "\n${LYELLOW}Compilando el código de la aplicación ...${NC}"
    cd ~/$repo
    docker-compose -p 295devops-travel-lamp --env-file .env.dev up -d --build
    docker ps
    echo "====================================="
}

if [ "${USERID}" -ne 0 ]; then
    echo -e "\n${LRED}Correr con usuario ROOT${NC}"
    exit
fi

echo "====================================="
sudo apt-get update
echo -e "\n${LGREEN}El servidor se encuentra Actualizado ...${NC}"
echo "====================================="

echo "====================================="
echo -e "\n${LBLUE}Ejecutar la etapa 1: [Init] ...${NC}"
install_packages
echo "====================================="

echo "====================================="
echo -e "\n${LBLUE}Ejecutar la etapa 2: [Build] ...${NC}"
build_application
echo "====================================="

echo "====================================="
echo -e "\n${LBLUE}Ejecutar la etapa 3: [Deploy] ...${NC}"
read -p "Ingrese el host de la aplicación: " host_url
read -p "Ingrese el token de acceso de tu bot de Discord: " token_discord
./discord.sh ~/$repo "${host_url%/}/" "${token_discord}"
echo "====================================="