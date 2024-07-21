# Function to check if Oh My Posh is installed
check_oh_my_posh() {
    if command -v oh-my-posh &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to check if wget is installed
check_wget() {
    if ! command -v wget &> /dev/null; then
        echo "Error: wget is not installed. Please install wget and try again."
        exit 1
    fi
}

# Define a backup function
backup_bashrc() {
    cp ~/.bashrc ~/.bashrc.bak
    echo "Backup created: ~/.bashrc.bak"
}

# Install Oh My Posh
install_oh_my_posh() {
    sudo wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
    sudo chmod +x /usr/local/bin/oh-my-posh
}

# Download and install themes
install_themes() {
    mkdir -p ~/.poshthemes
    wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
    unzip -q -o ~/.poshthemes/themes.zip -d ~/.poshthemes
    chmod u+rw ~/.poshthemes/*.omp.*
    rm ~/.poshthemes/themes.zip
}

# Modify bashrc safely
modify_bashrc() {
    local config_command="eval \"\$(oh-my-posh init bash --config ~/.poshthemes/jv_sitecorian.omp.json)\""

    # Backup .bashrc
    backup_bashrc

    # Check if already in .bashrc
    if ! grep -Fxq "$config_command" ~/.bashrc; then
        echo "$config_command" >> ~/.bashrc
        echo "Initialization command added to .bashrc."
    else
        echo "Initialization command already exists in .bashrc."
    fi
}

# Uninstall Oh My Posh
uninstall_oh_my_posh() {
    # Remove Oh My Posh binary
    sudo rm -f /usr/local/bin/oh-my-posh
    echo "Removed Oh My Posh binary."

    # Remove themes
    rm -rf ~/.poshthemes
    echo "Removed Oh My Posh themes."

    # Remove initialization command from .bashrc
    local config_command="eval \"\$(oh-my-posh init bash --config ~/.poshthemes/jv_sitecorian.omp.json)\""
    
    if grep -Fxq "$config_command" ~/.bashrc; then
        sed -i "\|$config_command|d" ~/.bashrc
        echo "Removed initialization command from .bashrc."
    fi

    echo "Oh My Posh uninstalled successfully."
}

# Main script execution
case "$1" in
    install)
        check_wget

        # Check if Oh My Posh is installed
        check_oh_my_posh && { echo "Oh My Posh is already installed."; exit 0; }

        install_oh_my_posh
        install_themes

        # Check if the theme config exists before modifying bashrc
        if [ -f ~/.poshthemes/jv_sitecorian.omp.json ]; then
            modify_bashrc
        else
            echo "Theme config jv_sitecorian.omp.json not found. Please check the extracted files."
        fi
        ;;
    uninstall)
        check_oh_my_posh || { echo "Oh My Posh is not installed."; exit 0; }

        uninstall_oh_my_posh
        ;;
    *)
        echo "Usage: $0 {install|uninstall}"
        exit 1
        ;;
esac
