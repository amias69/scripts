#!/bin/bash

# Detectar la distribución del sistema
if [ -f /etc/debian_version ]; then
    DISTRO="debian"
    UPDATE_CMD="sudo apt update && sudo apt upgrade -y"
    INSTALL_CMD="sudo apt install -y"
elif [ -f /etc/arch-release ]; then
    DISTRO="arch"
    UPDATE_CMD="sudo pacman -Syu --noconfirm"
    INSTALL_CMD="sudo pacman -S --noconfirm"
else
    echo "Distribución no soportada. Este script es compatible con Debian y Arch."
    exit 1
fi

# Actualizar el sistema
echo "Actualizando el sistema en $DISTRO..."
eval "$UPDATE_CMD"

# Instalar zsh si no está instalado
if ! command -v zsh >/dev/null 2>&1; then
    echo "Instalando zsh..."
    eval "$INSTALL_CMD zsh"
else
    echo "zsh ya está instalado."
fi

# Cambiar la shell predeterminada a zsh
if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "Cambiando la shell predeterminada a zsh..."
    chsh -s "$(command -v zsh)"
    echo "Reinicia la terminal para usar zsh como shell predeterminada."
else
    echo "zsh ya es la shell predeterminada."
fi


# Instalar la fuente Fira Code Nerd Font
echo "Instalando Fira Code Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
cd "$FONT_DIR" || exit
wget -qO "FiraCode.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
unzip -o FiraCode.zip
rm FiraCode.zip
fc-cache -fv
echo "Fuente Fira Code Nerd Font instalada."

#Agregar esta linea a la config de zsh


# Finalización
echo "¡Listo! El sistema está actualizado, zsh instalado, Starship configurado y Fira Code Nerd Font instalada."
echo "Abre una nueva terminal o ejecuta 'zsh' para usar la configuración."
