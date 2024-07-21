# Define a backup function
backup_bashrc() {
    cp ~/.bashrc ~/.bashrc.bak
    echo "Backup created: ~/.bashrc.bak"
}

# Install Oh My Posh
install_oh_my_posh() {
    sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
    sudo chmod +x /usr/local/bin/oh-my-posh
}

# Download and install themes
install_themes() {
    mkdir -p ~/.poshthemes
    wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
    unzip -o ~/.poshthemes/themes.zip -d ~/.poshthemes
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

# Main script execution
install_oh_my_posh
install_themes

# Check if the theme config exists before modifying bashrc
if [ -f ~/.poshthemes/jv_sitecorian.omp.json ]; then
    modify_bashrc
else
    echo "Theme config jv_sitecorian.omp.json not found. Please check the extracted files."
fi
