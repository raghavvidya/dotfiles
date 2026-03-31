#!/bin/sh
# POSIX-safe bootstrap

# Ensure install.sh runs only in zsh interactive shells
echo '. /home/vscode/dotfiles/install.sh' >> /home/vscode/.zshrc
