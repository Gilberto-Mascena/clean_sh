#!/bin/bash

# Limpeza de pacotes
sudo apt autoclean -y && sudo apt autoremove -y

# Atualização de pacotes
sudo apt update && sudo apt upgrade -y

# Atualização de pacotes Snap
sudo snap refresh

# Limpeza da lixeira do usuário
sudo rm -rf /home/$USER/.local/share/Trash/files/*
sudo rm -rf /home/$USER/.local/share/Trash/expunged/*
sudo rm -rf /home/$USER/.local/share/Trash/info/*

# Desfragmentação do sistema de arquivos
sudo /sbin/fstrim --all || true

# Limpeza dos logs do sistema
sudo journalctl --vacuum-time=2d

echo " "
echo "Limpeza e atualização concluída com sucesso!"
