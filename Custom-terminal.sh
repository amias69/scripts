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

# Instalar Starship
if ! command -v starship >/dev/null 2>&1; then
    echo "Instalando Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo "Starship ya está instalado."
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

# Crear o modificar la configuración de Starship
STARSHIP_CONFIG="$HOME/.config/starship.toml"
mkdir -p "$(dirname "$STARSHIP_CONFIG")"

cat > "$STARSHIP_CONFIG" <<EOL
# Configuración de Starship para el prompt
add_newline = false

# Este formato debe ser una cadena de texto
format = """
┌──([$username@$hostname])-[\$directory]
└─\$character
"""

[character]
success_symbol = "\$"
error_symbol = "❌\$" # Puedes personalizar el símbolo de error si quieres

[hostname]
ssh_only = false # Siempre muestra el hostname
format = "$hostname" # Muestra solo el hostname, sin extras

[directory]
truncate_to_repo = false # No trunca a repositorios
truncation_length = 2 # Ajusta cuántos directorios mostrar
format = "[\$path]" # Muestra el directorio actual entre corchetes

EOL
echo "Configuración de Starship creada en $STARSHIP_CONFIG."

# Agregar Starship a ~/.zshrc
ZSHRC="$HOME/.zshrc"
if ! grep -Fxq 'eval "$(starship init zsh)"' "$ZSHRC"; then
    echo 'eval "$(starship init zsh)"' >> "$ZSHRC"
    echo "Configuración de Starship añadida a ~/.zshrc."
else
    echo "Starship ya está configurado en ~/.zshrc."
fi

# Finalización
echo "¡Listo! El sistema está actualizado, zsh instalado, Starship configurado y Fira Code Nerd Font instalada."
echo "Abre una nueva terminal o ejecuta 'zsh' para usar la configuración."
