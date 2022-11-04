#! /bin/bash

# ------------------------------------------------------

## Ask for sudo

# ------------------------------------------------------

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

EXISTS=" exists. Skipping install...\n\n"

pacman -Syu --needed --noconfirm exa git sudo github-cli
echo 

printf "Installing tailscale...\n"
FILE=/bin/tailscale
if test -f "$FILE"; then
    printf "$FILE$EXISTS"
else
    curl -fsSL https://tailscale.com/install.sh | sh
fi

printf "Installing Rustup...\n"
FILE=/bin/rustup
if test -f "$FILE"; then
    printf "$FILE$EXISTS"
else
    curl https://sh.rustup.rs -sSf | sh
fi

printf "Installing Helix Editor...\n"
FILE=/home/$SUDO_USER/.cargo/bin/hx
if test -f "$FILE"; then
    printf "$FILE$EXISTS"
else
    su $SUDO_USER
    ./hx.sh
fi

printf "Installing Oh-My-Posh... \n"
FILE=/usr/local/bin/oh-my-posh
if test -f "$FILE"; then
    printf "$FILE$EXISTS"
else
    su $SUDO_USER
    ./omp.sh
fi

if systemd-detect-virt | grep 'oracle'; then
    printf "System is virtual\n"
    usermod -a -G vboxsf "$SUDO_USER"
else
    printf "System is physical\n"
fi

# printf "\n\n" >> /home/$SUDO_USER/.bashrc
# printf "alias ls='exa -lGh'\n" >> /home/$SUDO_USER/.bashrc

su $SUDO_USER
exec bash