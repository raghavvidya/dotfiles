#!/bin/sh
# POSIX-safe bootstrap

# Ensure install.sh runs only in zsh interactive shells
echo '. /home/vscode/dotfiles/install.sh' >> /home/vscode/.zshrc
wget https://github.com/kubecolor/kubecolor/releases/download/v0.4.0/kubecolor_0.4.0_linux_amd64.tar.gz
tar xvf kubecolor_0.4.0_linux_amd64.tar.gz
sudo mv kubecolor /usr/local/bin/
mkdir -p /home/vscode/.kube/
curl -fsSL https://raw.githubusercontent.com/ministryofjustice/analytical-platform/e44cf29bfe0400af600987e1bc4763cdff83099a/.devcontainer/src/kubernetes/config -o /home/vscode/.kube/config

