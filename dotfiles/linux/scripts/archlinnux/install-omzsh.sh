#!/usr/bin/env bash

if ! type "which" > /dev/null; then
    read -r -p "'which' command is not found. Download it via pacman? [Y/n]" response
    response=${response,,} # tolower
    if [[ $response =~ ^(y| ) ]] || [[ -z $response ]]; then
        sudo pacman -S which;
    fi
fi

if ! type "zsh" > /dev/null; then
    read -r -p "Download zsh via pacman? [Y/n]" response
    response=${response,,} # tolower
    if [[ $response =~ ^(y| ) ]] || [[ -z $response ]]; then
        echo "Installing zsh";
        sudo pacman -S zsh;
        echo "Zsh installed:";
    else
        echo "Skipping zsh installation."
    fi
else
    echo "Zsh has already been installed.";
fi

zshIsSetAsDefault=0
if [[ "$SHELL" == "/usr/bin/bash" ]]; then
    read -r -p "Do you want to set zsh as a default shell? [Y/n]" response
    response=${response,,} # tolower
    if [[ $response =~ ^(y| ) ]] || [[ -z $response ]]; then
        chsh -s $(which zsh)
        echo "Zsh is a default shell now."
        zshIsSetAsDefault=1
    else
        echo "Ok, but change it by yourself."
    fi
fi

echo "Current shell:"
echo $SHELL;
$SHELL --version;

if ! type "curl" > /dev/null; then
    read -r -p "'curl' command is not found. Download it via pacman? [Y/n]" response
    response=${response,,} # tolower
    if [[ $response =~ ^(y| ) ]] || [[ -z $response ]]; then
        sudo pacman -S curl;
    fi
fi

if ! ls "/home/$USER/.oh-my-zsh" > /dev/null; then
    echo "Intalling OMZSH:";
    read -r -p "Im a noob scripter... Please, 'exit' after omzsh installation :) [OK]" response;
    sh -c "$(curl -fsSL https://install.ohmyz.sh)";
    echo "All installation completed successfully.";
else
    echo "OhMyZsh has already been installed."
fi

if [[ $zshIsSetAsDefault == 1 ]]; then
    read -r -p "Changing default shell to zsh requires a system reboot. Reboot right NOW? [Y/n]" respose
    response=${response,,}
    if [[ $response =~ ^(y| ) ]] || [[ -z $response ]]; then
        shutdown -r now
    fi
fi