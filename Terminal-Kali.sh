#!/bin/bash

# Este script sirve para tener terminal con la apariencia de Kali Linux 
# y de paso te instala pywal para personalizar los colores.

# Detectar la distribución de Linux
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "No se pudo detectar la distribución de Linux."
    exit 1
fi

echo "Distribución detectada: $DISTRO"

# Verificar si zsh está instalado
if ! command -v zsh &> /dev/null; then
    echo "zsh no está instalado. Procediendo a instalarlo..."
    
    # Instalar zsh según la distribución
    case $DISTRO in
        debian|ubuntu)
            sudo apt update && sudo apt install zsh -y
            ;;
        fedora|rhel)
            sudo dnf install zsh -y
            ;;
        arch)
            sudo pacman -S zsh --noconfirm
            ;;
        *)
            echo "Distribución no reconocida o no soportada para la instalación automática."
            exit 1
            ;;
    esac
else
    echo "zsh ya está instalado."
fi

# Cambiar la shell por defecto a zsh
echo "Cambiando la shell por defecto a zsh para el usuario actual..."

# Comprobar si ya está configurada como zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    echo "Shell cambiada exitosamente a zsh. Reinicia tu terminal o cierra sesión para aplicar los cambios."
else
    echo "zsh ya es la shell por defecto."
fi

# Clonar el repositorio de Kali para obtener el tema y la configuración
echo "Clonando el repositorio de Kali Linux..."
if [ ! -d "kali-defaults" ]; then
    git clone https://gitlab.com/kalilinux/packages/kali-defaults.git
else
    echo "El repositorio de Kali ya está clonado."
fi

# Copiar el archivo .zshrc de Kali al directorio personal
echo "Copiando el archivo .zshrc de Kali al directorio personal..."
cp kali-defaults/etc/skel/.zshrc ~/

echo "El archivo .zshrc ha sido copiado exitosamente."

# Instalar pywal
echo "Instalando pywal..."

# Instalar pywal según la distribución
case $DISTRO in
    debian|ubuntu)
        sudo apt update && sudo apt install python3-pip -y
        pip3 install pywal
        ;;
    fedora|rhel)
        sudo dnf install python3-pip -y
        pip3 install pywal
        ;;
    arch|endeavouros)
        sudo pacman -S pywal --noconfirm
        ;;
    *)
        echo "Distribución no reconocida. Intentando instalar pywal con pip."
        pip3 install pywal
        ;;
esac

echo "pywal ha sido instalado exitosamente."

# Añadir la línea para cargar los colores de pywal en el archivo .zshrc
if ! grep -q "(cat ~/.cache/wal/sequences &)" ~/.zshrc; then
    echo "Añadiendo la línea para cargar los colores de pywal en .zshrc"
    echo "(cat ~/.cache/wal/sequences &)" >> ~/.zshrc
    echo "Línea añadida exitosamente."
else
    echo "La línea ya está presente en .zshrc."
fi

